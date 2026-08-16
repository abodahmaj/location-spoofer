package main

import (
	"fmt"
	"os"
	"path/filepath"
)

func main() {
	fmt.Println("🚀 Starting Paopao Location Spoofer Core...")

	// Check if running with arguments
	if len(os.Args) > 1 {
		switch os.Args[1] {
		case "version":
			fmt.Println("v0.1.0")
			return
		case "help":
			fmt.Println("Usage: location-spoofers-core [command]")
			fmt.Println("Commands:")
			fmt.Println("  version   Show version")
			fmt.Println("  help      Show this help")
			fmt.Println("")
			fmt.Println("Or start the proxy server directly.")
			return
		}
	}

	// Get current directory
	cwd, _ := os.Getwd()

	fmt.Printf("📍 Working directory: %s\n", cwd)
	fmt.Println("✅ Core is ready. Use from Swift app to start proxy.")
}
