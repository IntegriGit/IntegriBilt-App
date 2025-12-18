# IntegriBilt-App

A FastAPI-based Google Drive MCP Server with Bitwarden CLI integration.

## Bitwarden CLI Installation

This repository includes the **real Bitwarden CLI** for secure password management.

### Quick Install

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
bw --version
bw --help
```

### Usage

1. **Login to Bitwarden:**
   ```bash
   bw login
   ```

2. **Unlock your vault:**
   ```bash
   bw unlock
   ```
   This will provide a session key. Export it:
   ```bash
   export BW_SESSION="your-session-key"
   ```

3. **List items:**
   ```bash
   bw list items
   ```

4. **Get a specific item:**
   ```bash
   bw get item <item-name-or-id>
   ```

5. **Search for items:**
   ```bash
   bw list items --search <query>
   ```

6. **Generate a password:**
   ```bash
   bw generate --length 20 --uppercase --lowercase --number --special
   ```

7. **Lock the vault when done:**
   ```bash
   bw lock
   ```

### Common Commands

- `bw login` - Log into your Bitwarden account
- `bw logout` - Log out
- `bw unlock` - Unlock vault and get session key
- `bw lock` - Lock the vault
- `bw sync` - Sync vault with server
- `bw list items` - List all vault items
- `bw get item <id>` - Get specific item
- `bw create item <json>` - Create new item
- `bw edit item <id> <json>` - Edit item
- `bw delete item <id>` - Delete item
- `bw generate` - Generate password
- `bw status` - Show vault status

### Documentation

For complete documentation, visit: https://bitwarden.com/help/cli/

## Application Setup

### Prerequisites

- Python 3.10+
- Node.js (for Bitwarden CLI)
- Conda (optional, for environment management)

### Installation

1. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Install Bitwarden CLI:
   ```bash
   ./install-bitwarden.sh
   ```

3. Set up environment variables:
   ```bash
   cp env .env
   # Edit .env with your credentials
   ```

### Running the Application

```bash
uvicorn main:app --reload --port 8000
```

### Testing

```bash
pytest
```