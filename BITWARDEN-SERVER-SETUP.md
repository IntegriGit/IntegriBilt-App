# Bitwarden Server Local Development Setup

This guide will help you set up a local Bitwarden server for development purposes.

## Prerequisites

Before you start, ensure you have the following installed:

- **Docker Desktop** - For running dependencies (MSSQL, mail server, etc.)
- **Visual Studio 2022** or **Rider** (for Windows/macOS)
- **PowerShell** (pwsh)
- **.NET 8.0 SDK** - [Download here](https://dotnet.microsoft.com/download/dotnet/8.0)
- **Rust** (latest stable) - Install via [rustup](https://rustup.rs/)
- **Git**
- Your preferred database management tool (Azure Data Studio, DBeaver, etc.)

## Step 1: Clone the Bitwarden Server Repository

```bash
git clone https://github.com/bitwarden/server.git
cd server
```

## Step 2: Configure Git

```bash
# Ignore Prettier revision in blame
git config blame.ignoreRevsFile .git-blame-ignore-revs

# (Optional) Set up pre-commit dotnet format hook
git config --local core.hooksPath .git-hooks
```

**Note:** Formatting requires a full build. As an alternative, run `dotnet format` manually before requesting PR reviews.

## Step 3: Configure Docker

### 3.1 Set up environment file

```bash
cd dev
cp .env.example .env
```

### 3.2 Edit the .env file

Open `.env` and set the `MSSQL_PASSWORD` variable.

**Important:** Your MSSQL password must comply with these requirements:
- At least 8 characters long
- Contains characters from 3 of these 4 categories:
  - Latin uppercase letters (A-Z)
  - Latin lowercase letters (a-z)
  - Base 10 digits (0-9)
  - Non-alphanumeric characters (!, $, #, %)

Example:
```env
MSSQL_PASSWORD=MyStrongP@ss123
```

### 3.3 Start Docker containers

From the `dev` folder:

```bash
docker compose --profile mssql --profile mail up -d
```

This starts:
- **MSSQL** database server
- **MailCatcher** local mail server

You can manage containers using Docker Dashboard under the `bitwardenserver` group.

**⚠️ Warning:** If you change `MSSQL_PASSWORD` after first run, you must recreate the storage volume:

```bash
docker compose --profile mssql down
docker volume rm bitwardenserver_mssql_dev_data
# Then run docker compose up again
```

## Step 4: Verify Docker Services

### SQL Server
Connect using your database tool:
- **Server:** localhost
- **Port:** 1433
- **Username:** sa
- **Password:** (your MSSQL_PASSWORD from .env)

### MailCatcher
View caught emails at: http://localhost:1080

### Azurite (Bitwarden Developers Only)

If you're a Bitwarden developer, bootstrap Azurite:

```powershell
# Install Az module (may take a few minutes)
pwsh -Command "Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force"

# Run setup script
pwsh setup_azurite.ps1
```

## Step 5: Configure User Secrets

User secrets override settings in `appSettings.json` for local development.

### 5.1 Create secrets.json

```bash
cd dev
cp secrets.json.example secrets.json
```

### 5.2 Edit secrets.json

Update with your values:

```json
{
  "sqlServer": {
    "connectionString": "Server=localhost;Database=vault_dev;User Id=sa;Password=YOUR_PASSWORD_HERE;TrustServerCertificate=True"
  },
  "installation": {
    "id": "YOUR_INSTALLATION_ID",
    "key": "YOUR_INSTALLATION_KEY"
  },
  "licenseDirectory": "/path/to/empty/license/directory"
}
```

**Important:**
- Replace `YOUR_PASSWORD_HERE` with your MSSQL password
- Request hosting installation ID and Key from Bitwarden
- Set `licenseDirectory` to an empty directory for license files

### 5.3 Apply secrets to all projects

```powershell
pwsh setup_secrets.ps1

# Or clear existing secrets first:
pwsh setup_secrets.ps1 -clear
```

## Step 6: Create Database

Create the `vault_dev` database and run migrations:

```powershell
cd dev
pwsh migrate.ps1
```

You should see:
```
info: Bit.Migrator.DbMigrator[12482444]
     Migrating database.
info: Bit.Migrator.DbMigrator[12482444]
      Migration successful.
```

**Note:** Re-run `migrate.ps1` regularly to keep your database up-to-date.

## Step 7: Build and Run the Server

### 7.1 Start Identity Service

```bash
cd src/Identity
dotnet restore
dotnet run
```

Test at: http://localhost:33656/.well-known/openid-configuration

### 7.2 Start API Service (in new terminal)

```bash
cd src/Api
dotnet restore
dotnet run
```

Test at: http://localhost:4000/alive

## Step 8: Connect a Client

Configure any Bitwarden client to use your local server:
- **API URL:** http://localhost:4000
- **Identity URL:** http://localhost:33656

See: https://bitwarden.com/help/article/change-client-environment/

**Recommended:** Set up the Web Vault for administrative operations.

## Debugging

### Visual Studio
- **Windows:** Right-click each project → Debug → Start New Instance
- **macOS:** Right-click each project → Start Debugging Project

**Note:** On macOS, run `dotnet restore` for each project before debugging.

### Rider
Click the "Play" button for Api and Identity projects separately.

## Troubleshooting

### Can't connect to Api or Identity?
Check terminal output for the actual ports they're running on.

### Database connection issues?
Verify:
- Docker MSSQL container is running
- Password in secrets.json matches .env
- TrustServerCertificate=True is in connection string

### Migration failures?
Ensure MSSQL container is running and accessible.

## Quick Commands Reference

```bash
# Start services
docker compose --profile mssql --profile mail up -d

# Stop services
docker compose down

# Rebuild database (WARNING: deletes data)
docker compose --profile mssql down
docker volume rm bitwardenserver_mssql_dev_data

# Run migrations
pwsh migrate.ps1

# Apply secrets
pwsh setup_secrets.ps1

# Format code
dotnet format
```

## Additional Resources

- [Bitwarden Server Repository](https://github.com/bitwarden/server)
- [Contributing Documentation](https://contributing.bitwarden.com/)
- [Change Client Environment](https://bitwarden.com/help/article/change-client-environment/)
