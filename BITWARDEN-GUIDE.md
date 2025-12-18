# Bitwarden CLI Quick Reference

## Installation Status
✅ **Bitwarden CLI is installed** (Version 2025.12.0)
- Installed via: `npm install -g @bitwarden/cli`
- Location: `/usr/local/bin/bw`

## Quick Start

### 1. Login
```bash
bw login
# Follow the prompts to enter your email and master password
```

### 2. Unlock Vault
```bash
bw unlock
# This returns a session key - export it:
export BW_SESSION="your-session-key-here"
```

### 3. Basic Operations

#### List all items
```bash
bw list items
```

#### Search for items
```bash
bw list items --search "github"
```

#### Get a specific item
```bash
bw get item <item-id-or-name>
```

#### Get username/password
```bash
bw get username <item-id>
bw get password <item-id>
```

### 4. Password Generation

#### Generate random password
```bash
bw generate --length 20 --uppercase --lowercase --number --special
```

#### Generate passphrase
```bash
bw generate --passphrase --words 4 --separator "-"
```

### 5. Lock/Logout

#### Lock vault
```bash
bw lock
```

#### Logout completely
```bash
bw logout
```

## Advanced Usage

### Create a new item
```bash
bw get template item | jq '.name="New Item" | .login.username="user@example.com"' | bw encode | bw create item
```

### Edit an existing item
```bash
bw get item <id> | jq '.name="Updated Name"' | bw encode | bw edit item <id>
```

### Sync vault with server
```bash
bw sync
```

### Check vault status
```bash
bw status
```

### Use with scripts (non-interactive)
```bash
# Set session in environment
export BW_SESSION="your-session-key"

# Get password programmatically
PASSWORD=$(bw get password "My Login" 2>/dev/null)
```

## Common Use Cases

### 1. Auto-fill passwords in scripts
```bash
#!/bin/bash
# Ensure vault is unlocked
if [ -z "$BW_SESSION" ]; then
    echo "Please unlock vault: eval \$(bw unlock --raw)"
    exit 1
fi

# Get password
DB_PASSWORD=$(bw get password "Database Login")
```

### 2. Rotate passwords
```bash
# Generate new password
NEW_PASS=$(bw generate --length 24)

# Update in Bitwarden
bw get item <id> | jq ".login.password=\"$NEW_PASS\"" | bw encode | bw edit item <id>
```

### 3. Export vault (be careful!)
```bash
bw export --format json --output vault-backup.json
# Or encrypted format
bw export --format encrypted_json --output vault-backup.json
```

## Network Note

In sandboxed environments, you may see warnings about `api.bitwarden.com` being unreachable. 
This is expected and doesn't affect local operations like:
- Password generation
- Encoding/decoding
- Offline vault access (once synced)

On your production server or local machine, these warnings won't appear.

## Documentation

Full documentation: https://bitwarden.com/help/cli/

## Support

- GitHub: https://github.com/bitwarden/clients
- Community: https://community.bitwarden.com/
- Help Center: https://bitwarden.com/help/
