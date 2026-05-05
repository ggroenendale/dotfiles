# Database Credentials Configuration

This directory contains database credential configurations for use with database plugins like `dadbod.nvim`. These files are gitignored to prevent sensitive information from being committed to version control.

## Table of Contents
- [Files](#files)
- [Purpose](#purpose)
- [Setup Instructions](#setup-instructions)
- [Security Best Practices](#security-best-practices)
- [Connection String Formats](#connection-string-formats)
- [Sample Configuration](#sample-configuration)
- [Troubleshooting](#troubleshooting)

## Files

- **[db_credentials-sample.lua](db_credentials-sample.lua)** - Template file with placeholder values
- **[db_credentials.lua](db_credentials.lua)** - Actual credentials file (gitignored)

## Purpose

These credential files provide database connection strings for:
- Database browsing and querying with `dadbod.nvim`
- Database UI integration
- Secure storage of database credentials outside of version control

## Setup Instructions

### 1. Create Your Credentials File

Copy the sample file to create your actual credentials file:

```bash
cp db_credentials-sample.lua db_credentials.lua
```

### 2. Edit the Credentials File

Open `db_credentials.lua` and replace the placeholder values:

```lua
local username = "your_actual_username"
local password = "your_actual_password"
local host = "your_database_host"
local port = "5432"  -- Default PostgreSQL port
```

### 3. Add Your Database Connections

Modify the return table to include your actual database connections:

```lua
return {
    production_db = string.format("postgres://%s:%s@%s:%s/production", username, url_encode(password), host, port),
    staging_db = string.format("postgres://%s:%s@%s:%s/staging", username, url_encode(password), host, port),
    local_dev = "postgres://localhost:5432/development",
}
```

## Security Notes

### Git Ignore
The `db_credentials.lua` file is automatically gitignored via the `.gitignore` file. This prevents accidental commits of sensitive information.

### Password Encoding
Passwords are automatically URL-encoded using the `url_encode` function to handle special characters properly in connection strings.

### Local Development
For local development databases that don't require passwords, you can use simpler connection strings:

```lua
local_dev = "postgres://localhost:5432/development"
```

## Usage with Dadbod.nvim

Once configured, you can use these connections with `dadbod.nvim`:

### Open Database UI
- `<leader>db` - Open the database UI

### Connect to a Database
In the Dadbod UI:
1. Navigate to your connection name
2. Press `Enter` to connect
3. Browse tables, run queries, etc.

### Direct Connection in Commands
You can also use the connection strings directly in commands:

```vim
:DB postgres://username:password@host:port/database
```

## Connection String Format

The connection strings follow the standard PostgreSQL URI format:

```
postgres://username:password@host:port/database
```

### Supported Database Types
While the examples show PostgreSQL, you can use other database types:

- **PostgreSQL**: `postgres://...`
- **MySQL**: `mysql://...`
- **SQLite**: `sqlite:///path/to/database.db`
- **MSSQL**: `sqlserver://...`

## Best Practices

### 1. Use Environment Variables (Recommended)
For better security, consider using environment variables:

```lua
local username = os.getenv("DB_USERNAME") or "fallback_user"
local password = os.getenv("DB_PASSWORD") or "fallback_pass"
```

### 2. Separate Files per Environment
Consider creating separate credential files for different environments:

- `db_credentials-dev.lua` - Development credentials
- `db_credentials-prod.lua` - Production credentials (more secure storage)

### 3. Regular Rotation
Regularly rotate database passwords and update these credentials.

### 4. Access Control
Limit access to the `db_credentials.lua` file using file permissions:

```bash
chmod 600 db_credentials.lua
```

## Troubleshooting

### Connection Issues
1. **Check network connectivity**: Ensure you can reach the database host
2. **Verify credentials**: Double-check username, password, host, and port
3. **Check database permissions**: Ensure the user has access to the database

### Dadbod.nvim Issues
1. **Ensure plugin is installed**: Check `:Lazy status` for `dadbod.nvim`
2. **Check file syntax**: Ensure your Lua syntax is correct
3. **Restart Neovim**: Sometimes plugins need a restart to load new configurations

### Git Issues
If `db_credentials.lua` is accidentally committed:
1. Remove from git: `git rm --cached db_credentials.lua`
2. Add to `.gitignore`: Ensure it's in the ignore file
3. Commit the removal

## Sample Configuration

Here's a complete example with multiple database connections:

```lua
local function url_encode(str)
    if not str then
        return str
    end
    str = string.gsub(str, "([^%w%-%.%_%~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return str
end

-- Development environment (local)
local dev_username = "dev_user"
local dev_password = "dev_pass123"

-- Production environment (remote)
local prod_username = os.getenv("PROD_DB_USER")
local prod_password = os.getenv("PROD_DB_PASS")
local prod_host = "db.production.example.com"
local prod_port = "5432"

return {
    -- Local development databases
    local_postgres = "postgres://localhost:5432/postgres",
    local_app_db = "postgres://localhost:5432/myapp_development",

    -- Staging environment
    staging_db = string.format("postgres://%s:%s@staging.db.example.com:5432/staging",
                               dev_username, url_encode(dev_password)),

    -- Production environment (using env vars)
    production_db = string.format("postgres://%s:%s@%s:%s/production",
                                  prod_username, url_encode(prod_password), prod_host, prod_port),

    -- SQLite for testing
    test_db = "sqlite:///tmp/test.db",
}
```

