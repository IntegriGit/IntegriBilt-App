#!/bin/bash
# Install Bitwarden CLI
# This script installs the official Bitwarden CLI tool

set -e

echo "Installing Bitwarden CLI..."

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed. Please install Node.js and npm first."
    exit 1
fi

# Install Bitwarden CLI globally via npm
npm install -g @bitwarden/cli

# Verify installation
if command -v bw &> /dev/null; then
    echo "Bitwarden CLI installed successfully!"
    echo "Version: $(bw --version)"
    echo ""
    echo "Usage:"
    echo "  bw login                  # Login to your Bitwarden account"
    echo "  bw unlock                 # Unlock your vault"
    echo "  bw list items             # List all items in your vault"
    echo "  bw get item <name>        # Get a specific item"
    echo "  bw --help                 # Show all available commands"
    echo ""
    echo "For more information, visit: https://bitwarden.com/help/cli/"
else
    echo "Error: Bitwarden CLI installation failed."
    exit 1
fi
