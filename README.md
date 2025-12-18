# IntegriBilt-App

A FastAPI-based Google Drive MCP Server with Bitwarden integration.

## Bitwarden Integration Options

This repository supports two Bitwarden integration options:

### 1. Bitwarden CLI (Quick & Simple)
Perfect for password management and simple integrations.

**Quick Install:**
```bash
./install-bitwarden.sh
```

See [BITWARDEN-GUIDE.md](BITWARDEN-GUIDE.md) for complete CLI usage.

### 2. Bitwarden Server (Full Development Environment)
For developing and testing with a local Bitwarden server instance.

**Quick Setup:**
```bash
./setup-bitwarden-server.sh
```

See [BITWARDEN-SERVER-SETUP.md](BITWARDEN-SERVER-SETUP.md) for complete server setup guide.

---

## Bitwarden CLI - Quick Start

### Installation

Run the installation script:
```bash
./install-bitwarden.sh
```

Or install manually:
```bash
npm install -g @bitwarden/cli
```

### Verify Installation

```bash
bw --version  # Should show 2025.12.0
bw --help
```

### Basic Usage

1. **Login to Bitwarden:**
   ```bash
   bw login
   ```

2. **Unlock your vault:**
   ```bash
   bw unlock
   export BW_SESSION="your-session-key"
   ```

3. **List items:**
   ```bash
   bw list items
   ```

4. **Generate a password:**
   ```bash
   bw generate --length 20 --uppercase --lowercase --number --special
   ```

**📖 Full CLI Documentation:** [BITWARDEN-GUIDE.md](BITWARDEN-GUIDE.md)

---

## Bitwarden Server - Quick Start

### Prerequisites

- Docker Desktop
- .NET 8.0 SDK
- PowerShell (pwsh)
- Rust (via rustup)

### Quick Setup

```bash
# Run automated setup
./setup-bitwarden-server.sh
```

Or use Docker Compose for dependencies only:

```bash
# Start MSSQL and MailCatcher
docker compose -f docker-compose.bitwarden.yml up -d

# View MailCatcher web UI
open http://localhost:1080
```

### Manual Setup

1. **Clone Bitwarden server:**
   ```bash
   git clone https://github.com/bitwarden/server.git
   cd server
   ```

2. **Configure Docker:**
   ```bash
   cd dev
   cp .env.example .env
   # Edit .env and set MSSQL_PASSWORD
   docker compose --profile mssql --profile mail up -d
   ```

3. **Set up secrets:**
   ```bash
   cp secrets.json.example secrets.json
   # Edit secrets.json
   pwsh setup_secrets.ps1
   ```

4. **Create database:**
   ```bash
   pwsh migrate.ps1
   ```

5. **Run services:**
   ```bash
   # Terminal 1
   cd src/Identity
   dotnet restore && dotnet run
   
   # Terminal 2
   cd src/Api
   dotnet restore && dotnet run
   ```

**📖 Full Server Documentation:** [BITWARDEN-SERVER-SETUP.md](BITWARDEN-SERVER-SETUP.md)

---

## Application Setup

### Prerequisites

- Python 3.10+
- Node.js (for Bitwarden CLI)
- Conda (optional, for environment management)

### Installation

1. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Choose your Bitwarden integration:**
   
   **Option A - CLI only:**
   ```bash
   ./install-bitwarden.sh
   ```
   
   **Option B - Full server:**
   ```bash
   ./setup-bitwarden-server.sh
   ```

3. **Set up environment variables:**
   ```bash
   cp env .env
   # Edit .env with your credentials
   ```

### Running the Application

```bash
uvicorn main:app --reload --port 8000
```

Access at: http://localhost:8000

### Testing

```bash
pytest
```

---

## Quick Reference

### Bitwarden CLI Commands

```bash
bw login              # Login to Bitwarden
bw unlock             # Unlock vault
bw list items         # List all items
bw get item <name>    # Get specific item
bw generate           # Generate password
bw lock               # Lock vault
```

### Bitwarden Server URLs

- **API:** http://localhost:4000
- **Identity:** http://localhost:33656
- **MailCatcher:** http://localhost:1080

### Docker Services

```bash
# Start Bitwarden dependencies
docker compose -f docker-compose.bitwarden.yml up -d

# Stop services
docker compose -f docker-compose.bitwarden.yml down

# View logs
docker compose -f docker-compose.bitwarden.yml logs -f
```

---

## Documentation

- [Bitwarden CLI Guide](BITWARDEN-GUIDE.md) - Complete CLI usage and examples
- [Bitwarden Server Setup](BITWARDEN-SERVER-SETUP.md) - Full server development guide
- [Bitwarden Official Docs](https://bitwarden.com/help/cli/)
- [Bitwarden Contributing Guide](https://contributing.bitwarden.com/)

---

## Troubleshooting

### Bitwarden CLI

**Issue:** Network errors about api.bitwarden.com
- **Solution:** This is normal in sandboxed environments. Local operations (generate, encode) work fine.

### Bitwarden Server

**Issue:** Can't connect to MSSQL
- **Solution:** Check Docker container is running: `docker ps | grep mssql`

**Issue:** Database migration fails
- **Solution:** Ensure MSSQL password in secrets.json matches .env file

**Issue:** API/Identity won't start
- **Solution:** Check terminal output for actual ports being used

---

## Support & Resources

- [Bitwarden Help Center](https://bitwarden.com/help/)
- [Bitwarden Community Forums](https://community.bitwarden.com/)
- [Bitwarden GitHub](https://github.com/bitwarden)
- [Contributing Documentation](https://contributing.bitwarden.com/)