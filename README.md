# WordPress Docker Boilerplate Development Environment Starter Kit

A complete Docker-based WordPress development environment with WooCommerce, optimized for theme and plugin development.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Docker Compose installed
- No Docker Desktop required

### Installation

1. **Clone or create project directory:**
   ```bash
   mkdir wordpress-dev && cd wordpress-dev
   ```

2. **Download the configuration files:**
   - Copy `docker-compose.yml` to the project root
   - Create `config/` directory and add `php.ini`
   - Add `setup.sh` script

3. **Make setup script executable and run:**
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

4. **Access your development environment:**
   - **WordPress Site**: http://localhost:8080
   - **phpMyAdmin**: http://localhost:8081

## 📁 Project Structure

```
wordpress-dev/
├── .env.example              # Environment variables template
├── .gitignore               # Git ignore rules
├── LICENSE                  # MIT license
├── Makefile                 # Common commands
├── README.md
├── docker-compose.yml       # Docker services configuration
├── setup.sh                 # Automated setup script
├── config/
│   └── php.ini             # Custom PHP configuration
├── themes/                  # Your custom themes (mounted volume)
│   └── dev-theme/          # Basic starter theme
├── plugins/                 # Your custom plugins (mounted volume)
└── uploads/                 # Media uploads (mounted volume)
    └── .gitkeep            # Keep directory in git
```

## 🛠️ What's Included

### Services
- **WordPress** (latest) - Main application on port 8080
- **MySQL 8.0** - Database server on port 3306
- **phpMyAdmin** - Database management interface on port 8081
- **WP-CLI** - WordPress command-line interface

### Pre-installed Plugins
- **WooCommerce** - E-commerce functionality
- **Query Monitor** - Debugging and development insights
- **Debug Bar** - Additional debugging information
- **WP-Crontrol** - Cron job management

### Development Features
- WordPress debug mode enabled
- PHP error logging configured
- Increased memory and upload limits
- OPcache optimized for development
- Direct file access to themes and plugins

## 🎯 Daily Development Workflow

### Starting/Stopping Environment
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View service status
docker-compose ps

# View logs
docker-compose logs wordpress
```

### Theme Development
```bash
# Create new theme directory
mkdir themes/my-theme

# Edit theme files with your preferred IDE
# Files are automatically synced with the container

# Activate theme via WP-CLI
docker-compose exec wpcli wp theme activate my-theme --allow-root
```

### Plugin Development
```bash
# Create new plugin directory
mkdir plugins/my-plugin

# Create plugin scaffold
docker-compose exec wpcli wp scaffold plugin my-plugin --allow-root

# Activate plugin
docker-compose exec wpcli wp plugin activate my-plugin --allow-root
```

## 🗄️ Database Management

### Connection Details
- **Host**: localhost:3306 (from host machinels
- **Database**: wordpress (or value from .env)
- **Username**: wordpress (or value from .env)
- **Password**: Check your .env file

### phpMyAdmin Access
- **URL**: http://localhost:8081
- **Username**: root
- **Password**: Your MYSQL_ROOT_PASSWORD from .env

### Backup & Restore
```bash
# Export database
docker-compose exec wpcli wp db export backup.sql --allow-root

# Import database
docker-compose exec wpcli wp db import backup.sql --allow-root

# Search and replace URLs
docker-compose exec wpcli wp search-replace 'oldurl.com' 'localhost:8080' --allow-root
```

## 🔧 WP-CLI Commands

Access WordPress command-line interface for advanced operations:

```bash
# Enter WP-CLI container
docker-compose exec wpcli bash

# Or run commands directly
docker-compose exec wpcli wp --info --allow-root

# Common operations
docker-compose exec wpcli wp plugin list --allow-root
docker-compose exec wpcli wp theme list --allow-root
docker-compose exec wpcli wp user list --allow-root

# Install plugins
docker-compose exec wpcli wp plugin install contact-form-7 --activate --allow-root

# Update WordPress core
docker-compose exec wpcli wp core update --allow-root

# Database operations
docker-compose exec wpcli wp db export backup.sql --allow-root
docker-compose exec wpcli wp db import backup.sql --allow-root

# Search and replace (useful for URL changes)
docker-compose exec wpcli wp search-replace 'oldurl.com' 'localhost:8080' --allow-root
```

## 🗄️ Database
