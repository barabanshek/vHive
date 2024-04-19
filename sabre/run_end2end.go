package main

import (
	"context"
	"flag"
	"math/rand"
	"time"
	"fmt"
	"bytes"
	"os/exec"
	"regexp"
	"strconv"
	"os"

	"github.com/containerd/containerd/namespaces"
	log "github.com/sirupsen/logrus"
	ctriface "github.com/vhive-serverless/vhive/ctriface"
	"github.com/vhive-serverless/vhive/snapshotting"
)

// Configs.
var (
	isUPFEnabled = flag.Bool("upf", false, "Set UPF enabled")
	isLazyMode   = flag.Bool("lazy", false, "Set lazy serving on or off")
)

// AUX.
const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

var seededRand *rand.Rand = rand.New(rand.NewSource(time.Now().UnixNano()))

func generateRandomString(length int) string {
	b := make([]byte, length)
	for i := range b {
		b[i] = charset[seededRand.Intn(len(charset))]
	}
	return string(b)
}

// Functions.
func startVM(orch *ctriface.Orchestrator, ctx context.Context, image_name string, mem_size int) (error, string) {
	vmID := generateRandomString(10)
	rsp, metrics, err := orch.StartVM(ctx, vmID, image_name, mem_size)
	if err != nil {
		return fmt.Errorf("failed to StartVM: ", err), ""
	}
	log.Info("VM started, IP= %v", rsp.GuestIP)
	metrics.PrintAll()

	return nil, vmID
}

func stop(orch *ctriface.Orchestrator, ctx context.Context, vmID string) error {
	if err := orch.StopSingleVM(ctx, vmID); err != nil {
		return fmt.Errorf("failed to stopVM.", err)
	}
	log.Info("VM stopped")

	return nil
}

func getTimeElapsedMicroseconds(log string) (int, error) {
    re := regexp.MustCompile(`Time elapsed: (\d+) microseconds`)
    
    matches := re.FindStringSubmatch(log)
    if len(matches) < 2 {
        return 0, fmt.Errorf("no time data found")
    }

    microseconds, err := strconv.Atoi(matches[1])
    if err != nil {
        return 0, fmt.Errorf("invalid number format")
    }
    
    return microseconds, nil
}

func invokeServer(testInvocationCommand string) (int, error) {
	var sh_cmd *exec.Cmd = exec.Command("/bin/sh", "invoke.sh", testInvocationCommand)
	var outb, errb bytes.Buffer
	sh_cmd.Stdout = &outb
	sh_cmd.Stderr = &errb
	sh_err := sh_cmd.Run()
	if sh_err != nil {
		return -1, fmt.Errorf("failed to exec comand")
	}
	log.Info("Server invoked: ", outb.String(), errb.String())

	return getTimeElapsedMicroseconds(outb.String())
}

func dropCaches(orch *ctriface.Orchestrator, ctx context.Context) error {
	sh_cmd := exec.Command("/bin/sh", "drop_caches.sh")
	var outb, errb bytes.Buffer
	sh_cmd.Stdout = &outb
	sh_cmd.Stderr = &errb
	sh_err := sh_cmd.Run()
	if sh_err != nil {
		return fmt.Errorf("failed to drop caches")
	}
	log.Info("Caches droped: ", outb.String())

	// Pre-warm the hypervisor with a hello, world image.
	vmID_prewarm := generateRandomString(10)
	_, _, err := orch.StartVM(ctx, vmID_prewarm, "127.0.0.1:5000/hello_world:latest", 256)
	if err != nil {
		return fmt.Errorf("failed to start prewarm VM")
	}
	err = orch.StopSingleVM(ctx, vmID_prewarm)
	if err != nil {
		return fmt.Errorf("failed to stop prewarm VM")
	}

	return nil
}

func snapshot_basic(orch *ctriface.Orchestrator, ctx context.Context, vmID string, image_name string, mem_size int, snapshot_type snapshotting.SnapshotType) (error, float64) {
	if err := orch.PauseVM(ctx, vmID); err != nil {
		return fmt.Errorf("failed to PauseVM, error was: %v", err), -1
	}
	log.Info("VM paused")

	revision := "myrev-4"
	snap := snapshotting.NewSnapshot(revision, "/fccd/snapshots", image_name)
	if err := snap.CreateSnapDir(); err != nil {
		return fmt.Errorf("failed to CreateSnapDir %v", err), -1
	}

	// Set type of snapshot.
	snap.Type = snapshot_type

	if err := orch.CreateSnapshot(ctx, vmID, snap); err != nil {
		return fmt.Errorf("failed to CreateSnapshot %v", err), -1
	}
	log.Info("VM snapshotted")

	if _, err := orch.ResumeVM(ctx, vmID); err != nil {
		return fmt.Errorf("failed to ResumeVM %v", err), -1
	}
	log.Info("VM resumed")

	if err := orch.StopSingleVM(ctx, vmID); err != nil {
		return fmt.Errorf("failed to stopVM.", err), -1
	}
	log.Info("VM stopped")

	// Drop caches before loading from the snapshot.
	// This way, we emulate cold start in the same way as we would be
	// loading the snapshot on a new machine.
	if err := dropCaches(orch, ctx); err != nil {
		return fmt.Errorf("failed to srop caches."), -1
	}

	latency := 0.0
	if _, metrics, err := orch.LoadSnapshot(ctx, vmID, snap, mem_size); err != nil {
		return fmt.Errorf("failed to LoadSnapshot %v", err), -1
	} else {
		log.Info("VM loaded from the snapshot:")
		metrics.PrintAll()
		latency = metrics.Total()
	}

	return nil, latency
}

func main() {
	log.Info("Starting e2e experiments.")

	// Parse inputs.
	testImageNameFlag := flag.String("image", "image", "image name")
	testMemorySizeFlag := flag.Int("memsize", 256, "memory size in MB")
	testSnapshotTypeFlag := flag.String("snapshot", "Diff", "type of snapshot")
	testInvocationCmdFlag := flag.String("invoke_cmd", "...", "invocation command")
	flag.Parse()

	// Initialize the context.
	namespaceName := "firecracker-containerd"
	testTimeout := 120 * time.Second
	ctx, cancel := context.WithTimeout(namespaces.WithNamespace(context.Background(), namespaceName), testTimeout)
	defer cancel()

	// Create vHive orchestrator.
	snapshotter := flag.String("ss", "devmapper", "snapshotter name")
	testModeOn := false

	orch := ctriface.NewOrchestrator(
		*snapshotter,
		"",
		ctriface.WithTestModeOn(testModeOn),
		ctriface.WithUPF(*isUPFEnabled),
		ctriface.WithLazyMode(*isLazyMode),
	)

	//
	// Start a uVM and run examples.
	//
	error_ := false
	lat_restore_snapshot := 0.0
	lat_cold_start := -1
	if err, vmID := startVM(orch, ctx, *testImageNameFlag, *testMemorySizeFlag); err == nil {
		time.Sleep(10 * time.Second)

		// Invoke.
		if _, err := invokeServer(*testInvocationCmdFlag); err != nil {
			log.Fatal("Failed to invoke a function")
			error_ = error_ || true
		}

		time.Sleep(1 * time.Second)

		// Make a snapshot, load from snapshot.
		if *testSnapshotTypeFlag == "Diff" {
			log.Info("Running with Diff snapshot...")
			if err, lat := snapshot_basic(orch, ctx, vmID, *testImageNameFlag, *testMemorySizeFlag, snapshotting.DiffSnapshot); err != nil {
				log.Fatal("Failed to make-load snapshot")
				error_ = error_ || true
			} else {
				lat_restore_snapshot = lat
			}
		}
		if *testSnapshotTypeFlag == "DiffCompressed" {
			log.Info("Running with DiffCompressed (Sabre) snapshot...")
			if err, lat := snapshot_basic(orch, ctx, vmID, *testImageNameFlag, *testMemorySizeFlag, snapshotting.DiffSnapshotWithCompression); err != nil {
				log.Fatal("Failed to make-load snapshot")
				error_ = error_ || true
			} else {
				lat_restore_snapshot = lat
			}
		}

		time.Sleep(10 * time.Second)

		// Invoke again.
		if lat, err := invokeServer(*testInvocationCmdFlag); err != nil {
			log.Fatal("Failed to invoke a function")
			error_ = error_ || true
		} else {
			lat_cold_start = lat
		}

		if err := stop(orch, ctx, vmID); err != nil {
			error_ = error_ || true
		}		
	};

	if error_ == false {
		fmt.Fprintf(os.Stdout, "\033[0;31m %s\n", "Experiment finished, results: ")
		fmt.Fprintf(os.Stdout, "\033[0;31m %s %f\n", "    restore from snapshot (us): ", lat_restore_snapshot)
		fmt.Fprintf(os.Stdout, "\033[0;31m %s %d\n", "    cold start (us): ", lat_cold_start)
	} else {
		log.Fatal("Experiment crashed.")
	}
}
