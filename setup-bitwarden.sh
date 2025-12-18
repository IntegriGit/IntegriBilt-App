#!/bin/bash
# Bitwarden Integration Setup - Interactive Installer
# Helps you choose and install the right Bitwarden option

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

clear

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║                                                      ║"
echo "║        Bitwarden Integration Setup Wizard           ║"
echo "║                                                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

echo "This wizard will help you set up Bitwarden for your needs."
echo ""
echo "Available options:"
echo ""
echo -e "${GREEN}1. Bitwarden CLI${NC} (Recommended for most users)"
echo "   - Quick installation (< 1 minute)"
echo "   - Perfect for password management"
echo "   - Works with existing Bitwarden account"
echo "   - Lightweight and simple"
echo ""
echo -e "${YELLOW}2. Bitwarden Server${NC} (For developers)"
echo "   - Full local server setup (15-30 minutes)"
echo "   - Requires Docker, .NET 8.0, Rust"
echo "   - For development and testing"
echo "   - Complete server environment"
echo ""
echo -e "${BLUE}3. Both${NC} (CLI + Server)"
echo "   - Install both options"
echo "   - Maximum flexibility"
echo ""

read -p "Enter your choice (1/2/3): " CHOICE

case $CHOICE in
    1)
        echo ""
        echo -e "${GREEN}Installing Bitwarden CLI...${NC}"
        echo ""
        
        if [ ! -f "./install-bitwarden.sh" ]; then
            echo -e "${RED}Error: install-bitwarden.sh not found${NC}"
            exit 1
        fi
        
        chmod +x ./install-bitwarden.sh
        ./install-bitwarden.sh
        
        echo ""
        echo -e "${GREEN}✓ Bitwarden CLI installed successfully!${NC}"
        echo ""
        echo "Quick start:"
        echo "  1. Login: bw login"
        echo "  2. Unlock: bw unlock"
        echo "  3. Use: bw list items"
        echo ""
        echo "📖 See BITWARDEN-GUIDE.md for complete documentation"
        ;;
        
    2)
        echo ""
        echo -e "${YELLOW}Setting up Bitwarden Server...${NC}"
        echo ""
        
        if [ ! -f "./setup-bitwarden-server.sh" ]; then
            echo -e "${RED}Error: setup-bitwarden-server.sh not found${NC}"
            exit 1
        fi
        
        chmod +x ./setup-bitwarden-server.sh
        ./setup-bitwarden-server.sh
        
        echo ""
        echo -e "${GREEN}✓ Bitwarden Server setup initiated${NC}"
        echo ""
        echo "📖 See BITWARDEN-SERVER-SETUP.md for complete documentation"
        ;;
        
    3)
        echo ""
        echo -e "${BLUE}Installing both Bitwarden CLI and Server...${NC}"
        echo ""
        
        # Install CLI first
        echo -e "${GREEN}Step 1: Installing Bitwarden CLI...${NC}"
        if [ -f "./install-bitwarden.sh" ]; then
            chmod +x ./install-bitwarden.sh
            ./install-bitwarden.sh
            echo -e "${GREEN}✓ CLI installed${NC}"
        else
            echo -e "${RED}Error: install-bitwarden.sh not found${NC}"
            exit 1
        fi
        
        echo ""
        echo -e "${YELLOW}Step 2: Setting up Bitwarden Server...${NC}"
        if [ -f "./setup-bitwarden-server.sh" ]; then
            chmod +x ./setup-bitwarden-server.sh
            ./setup-bitwarden-server.sh
            echo -e "${GREEN}✓ Server setup initiated${NC}"
        else
            echo -e "${RED}Error: setup-bitwarden-server.sh not found${NC}"
            exit 1
        fi
        
        echo ""
        echo -e "${GREEN}✓ Both installations complete!${NC}"
        echo ""
        echo "Documentation:"
        echo "  📖 CLI: BITWARDEN-GUIDE.md"
        echo "  📖 Server: BITWARDEN-SERVER-SETUP.md"
        ;;
        
    *)
        echo ""
        echo -e "${RED}Invalid choice. Please run again and select 1, 2, or 3.${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Setup complete! Thank you for using Bitwarden.${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""
