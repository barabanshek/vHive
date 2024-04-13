package main

import (
	"context"
	"flag"
	"math/rand"
	"time"

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

func main() {
	log.Info("Starting e2e experiments.")

	// Parse inputs.
	testImageNameFlag := flag.String("image", "image", "image")
	testMemorySizeFlag := flag.Int("memsize", 256, "memory size in MB")
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

	// Start a uVM.
	vmID := generateRandomString(10)
	rsp, metrics, err := orch.StartVM(ctx, vmID, *testImageNameFlag, *testMemorySizeFlag)
	if err != nil {
		log.Fatalf("failed to StartVM %v", err)
	}
	log.Info("VM started, IP= %v", rsp.GuestIP)
	metrics.PrintAll()

	time.Sleep(5 * time.Second)

	// Make snapshot.
	err = orch.PauseVM(ctx, vmID)
	if err != nil {
		log.Fatalf("failed to PauseVM %v", err)
	}
	log.Info("VM paused")

	revision := "myrev-4"
	snap := snapshotting.NewSnapshot(revision, "/fccd/snapshots", *testImageNameFlag)
	err = snap.CreateSnapDir()
	if err != nil {
		log.Fatalf("failed to CreateSnapDir %v", err)
	}

	err = orch.CreateSnapshot(ctx, vmID, snap)
	if err != nil {
		log.Fatalf("failed to CreateSnapshot %v", err)
	}
	log.Info("VM snapshotted")

	_, err = orch.ResumeVM(ctx, vmID)
	if err != nil {
		log.Fatalf("failed to ResumeVM %v", err)
	}
	log.Info("VM resumed")

	time.Sleep(5 * time.Second)

	// Stop the uVM.
	err = orch.StopSingleVM(ctx, vmID)
	if err != nil {
		log.Fatalf("failed to StopVM %v", err)
	}
	log.Info("VM stopped")

	log.Info("The e2e experimens are finished, bye!")
}
