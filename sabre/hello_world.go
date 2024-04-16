package main

import (
	"context"
	"flag"
	"math/rand"
	"time"
	"fmt"

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

// Examples.
func stop(orch *ctriface.Orchestrator, ctx context.Context, vmID string) error {
	if err := orch.StopSingleVM(ctx, vmID); err != nil {
		return fmt.Errorf("failed to stopVM.", err)
	}
	log.Info("VM stopped")

	return nil
}

func snapshot_basic(orch *ctriface.Orchestrator, ctx context.Context, vmID string, image_name string, mem_size int, snapshot_type snapshotting.SnapshotType) error {
	if err := orch.PauseVM(ctx, vmID); err != nil {
		return fmt.Errorf("failed to PauseVM, error was: %v", err)
	}
	log.Info("VM paused")

	revision := "myrev-4"
	snap := snapshotting.NewSnapshot(revision, "/fccd/snapshots", image_name)
	if err := snap.CreateSnapDir(); err != nil {
		return fmt.Errorf("failed to CreateSnapDir %v", err)
	}

	snap.Type = snapshot_type

	if err := orch.CreateSnapshot(ctx, vmID, snap); err != nil {
		return fmt.Errorf("failed to CreateSnapshot %v", err)
	}
	log.Info("VM snapshotted")

	if _, err := orch.ResumeVM(ctx, vmID); err != nil {
		return fmt.Errorf("failed to ResumeVM %v", err)
	}
	log.Info("VM resumed")

	if err := orch.StopSingleVM(ctx, vmID); err != nil {
		return fmt.Errorf("failed to stopVM.", err)
	}
	log.Info("VM stopped")

	if _, metrics, err := orch.LoadSnapshot(ctx, vmID, snap, mem_size); err != nil {
		return fmt.Errorf("failed to LoadSnapshot %v", err)
	} else {
		log.Info("VM loaded from the snapshot:")
		metrics.PrintAll()
	}

	if err := orch.StopSingleVM(ctx, vmID); err != nil {
		return fmt.Errorf("failed to stopVM.", err)
	}
	log.Info("VM stopped")

	return nil
}

func main() {
	log.Info("Starting e2e experiments.")

	// Parse inputs.
	testImageNameFlag := flag.String("image", "image", "image name")
	testMemorySizeFlag := flag.Int("memsize", 256, "memory size in MB")
	testExampleNameFlag := flag.String("example", "start-stop", "example to execuute")
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
	error_ := fmt.Errorf("")
	if err, vmID := startVM(orch, ctx, *testImageNameFlag, *testMemorySizeFlag); err == nil {
		// Run experiments.
		switch *testExampleNameFlag {
		case "start-stop": error_ = stop(orch, ctx, vmID)
		case "start-snapshot-stop-resume-stop": error_ = snapshot_basic(orch, ctx, vmID, *testImageNameFlag, *testMemorySizeFlag, snapshotting.FullSnapshot)
		case "start-diff-snapshot-stop-resume-stop": error_ = snapshot_basic(orch, ctx, vmID, *testImageNameFlag, *testMemorySizeFlag, snapshotting.DiffSnapshot)
		default: {
			log.Info("Unknown experiment.")
			error_ = stop(orch, ctx, vmID)
		}
		}
	};

	if error_ == nil {
		log.Info("Examples finished, bye!")
	} else {
		log.Fatal("Examples crashed.")
	}
}
