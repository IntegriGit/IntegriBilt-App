#!/bin/bash
# Bitwarden Server Development Environment Setup
# This script sets up a local Bitwarden server for development

set -e

echo "========================================"
echo "Bitwarden Server Development Setup"
echo "========================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${NC}ℹ $1${NC}"
}

# Check prerequisites
echo "Checking prerequisites..."
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker Desktop."
    exit 1
else
    print_success "Docker is installed"
fi

# Check .NET 8.0
if ! command -v dotnet &> /dev/null; then
    print_error ".NET SDK is not installed. Please install .NET 8.0 SDK."
    exit 1
else
    DOTNET_VERSION=$(dotnet --version)
    print_success ".NET SDK is installed (version $DOTNET_VERSION)"
fi

# Check PowerShell
if ! command -v pwsh &> /dev/null; then
    print_warning "PowerShell (pwsh) is not installed. Some setup scripts may not work."
    print_info "Install from: https://github.com/PowerShell/PowerShell"
else
    print_success "PowerShell is installed"
fi

# Check Rust
if ! command -v rustc &> /dev/null; then
    print_warning "Rust is not installed. Some components may fail to build."
    print_info "Install from: https://rustup.rs/"
else
    RUST_VERSION=$(rustc --version)
    print_success "Rust is installed ($RUST_VERSION)"
fi

# Check Git
if ! command -v git &> /dev/null; then
    print_error "Git is not installed."
    exit 1
else
    print_success "Git is installed"
fi

echo ""
echo "========================================"
echo "Step 1: Clone Bitwarden Server Repository"
echo "========================================"
echo ""

# Ask user where to clone
read -p "Enter directory to clone Bitwarden server (default: ./bitwarden-server): " CLONE_DIR
CLONE_DIR=${CLONE_DIR:-./bitwarden-server}

if [ -d "$CLONE_DIR" ]; then
    print_warning "Directory $CLONE_DIR already exists."
    read -p "Use existing directory? (y/n): " USE_EXISTING
    if [ "$USE_EXISTING" != "y" ]; then
        print_info "Exiting. Please specify a different directory."
        exit 0
    fi
else
    print_info "Cloning Bitwarden server repository..."
    git clone https://github.com/bitwarden/server.git "$CLONE_DIR"
    print_success "Repository cloned to $CLONE_DIR"
fi

cd "$CLONE_DIR"

echo ""
echo "========================================"
echo "Step 2: Configure Git"
echo "========================================"
echo ""

git config blame.ignoreRevsFile .git-blame-ignore-revs
print_success "Git blame configuration applied"

read -p "Set up pre-commit dotnet format hook? (y/n): " SETUP_HOOKS
if [ "$SETUP_HOOKS" = "y" ]; then
    git config --local core.hooksPath .git-hooks
    print_success "Pre-commit hooks configured"
else
    print_info "Skipped pre-commit hooks setup"
fi

echo ""
echo "========================================"
echo "Step 3: Configure Docker Environment"
echo "========================================"
echo ""

cd dev

if [ ! -f .env ]; then
    cp .env.example .env
    print_success ".env file created"
    
    print_warning "Please edit dev/.env and set your MSSQL_PASSWORD"
    print_info "Password requirements:"
    print_info "  - At least 8 characters"
    print_info "  - Must include 3 of: uppercase, lowercase, digits, special chars"
    
    read -p "Press Enter to open .env in editor..." 
    
    # Find available editor
    if [ -n "$EDITOR" ]; then
        $EDITOR .env
    elif command -v nano &> /dev/null; then
        nano .env
    elif command -v vi &> /dev/null; then
        vi .env
    elif command -v vim &> /dev/null; then
        vim .env
    else
        print_warning "No editor found. Please edit dev/.env manually."
    fi
else
    print_info ".env file already exists"
fi

echo ""
echo "========================================"
echo "Step 4: Start Docker Containers"
echo "========================================"
echo ""

print_info "Starting MSSQL and mail server containers..."
docker compose --profile mssql --profile mail up -d

if [ $? -eq 0 ]; then
    print_success "Docker containers started successfully"
    print_info "MSSQL: localhost:1433 (username: sa)"
    print_info "MailCatcher: http://localhost:1080"
else
    print_error "Failed to start Docker containers"
    exit 1
fi

echo ""
echo "========================================"
echo "Step 5: Configure User Secrets"
echo "========================================"
echo ""

if [ ! -f secrets.json ]; then
    cp secrets.json.example secrets.json
    print_success "secrets.json created"
    
    print_warning "Please edit dev/secrets.json with your configuration"
    print_info "Required changes:"
    print_info "  - sqlServer.connectionString: Update password"
    print_info "  - installation.id and installation.key: Request from Bitwarden"
    print_info "  - licenseDirectory: Set to empty directory path"
    
    read -p "Press Enter to open secrets.json in editor..."
    
    # Find available editor
    if [ -n "$EDITOR" ]; then
        $EDITOR secrets.json
    elif command -v nano &> /dev/null; then
        nano secrets.json
    elif command -v vi &> /dev/null; then
        vi secrets.json
    elif command -v vim &> /dev/null; then
        vim secrets.json
    else
        print_warning "No editor found. Please edit dev/secrets.json manually."
    fi
else
    print_info "secrets.json already exists"
fi

if command -v pwsh &> /dev/null; then
    print_info "Applying secrets to all projects..."
    pwsh setup_secrets.ps1
    print_success "User secrets configured"
else
    print_warning "PowerShell not available. Please run 'pwsh setup_secrets.ps1' manually"
fi

echo ""
echo "========================================"
echo "Step 6: Create Database"
echo "========================================"
echo ""

print_info "Waiting for MSSQL to be ready..."
sleep 10

if command -v pwsh &> /dev/null; then
    print_info "Creating database and running migrations..."
    pwsh migrate.ps1
    
    if [ $? -eq 0 ]; then
        print_success "Database created and migrations completed"
    else
        print_error "Database migration failed"
        exit 1
    fi
else
    print_warning "PowerShell not available. Please run 'pwsh migrate.ps1' manually"
fi

cd ..

echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
print_success "Bitwarden server development environment is ready!"
echo ""
print_info "Next steps:"
echo ""
echo "1. Start the Identity service:"
echo "   cd src/Identity"
echo "   dotnet restore"
echo "   dotnet run"
echo ""
echo "2. Start the API service (in another terminal):"
echo "   cd src/Api"
echo "   dotnet restore"
echo "   dotnet run"
echo ""
echo "3. Test the services:"
echo "   Identity: http://localhost:33656/.well-known/openid-configuration"
echo "   API: http://localhost:4000/alive"
echo ""
echo "4. Configure your Bitwarden client:"
echo "   API URL: http://localhost:4000"
echo "   Identity URL: http://localhost:33656"
echo ""
print_info "For more information, see BITWARDEN-SERVER-SETUP.md"
echo ""
