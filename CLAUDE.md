# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup
```bash
bin/setup                    # Initial application setup
bundle install              # Install Ruby dependencies
```

### Development Server
```bash
bin/dev                     # Start development server with CSS watching (uses Procfile.dev)
bin/rails server           # Start Rails server only
bin/rails tailwindcss:watch # Watch and compile Tailwind CSS
```

### Database
```bash
bin/rails db:create         # Create databases
bin/rails db:migrate        # Run pending migrations
bin/rails db:seed          # Seed database with initial data
bin/rails db:setup         # Create, migrate, and seed database
```

### Testing & Quality
```bash
bin/rubocop                 # Run Ruby linter (uses Omakase styling)
bin/rubocop -f github       # Run linter with GitHub Actions format
bin/brakeman               # Run security vulnerability scanner
bin/importmap audit        # Audit JavaScript dependencies for security issues
```

### Asset Management
```bash
bin/importmap              # Manage JavaScript import maps
bin/rails assets:precompile # Precompile assets for production
```

### Deployment
```bash
bin/kamal                  # Kamal deployment commands
bin/thrust                 # HTTP asset caching and compression
```

## Architecture Overview

This is a modern Rails 8 application with the following key characteristics:

### Framework Stack
- **Rails 8.x** with modern defaults
- **Hotwire** (Turbo + Stimulus) for SPA-like interactions
- **Tailwind CSS** for styling via `tailwindcss-rails`
- **PostgreSQL** as the primary database
- **Propshaft** as the asset pipeline
- **Import Maps** for JavaScript module management

### Core Infrastructure
- **Solid Queue** - Database-backed job processing
- **Solid Cache** - Database-backed caching
- **Solid Cable** - Database-backed Action Cable
- **Puma** web server with **Thruster** for production optimization

### Application Structure
- Standard Rails MVC architecture in `app/`
- Currently minimal with base Rails classes (ApplicationController, ApplicationRecord, etc.)
- No custom models, controllers, or views implemented yet
- Routes are minimal with only health check endpoint at `/up`

### Code Quality & Security
- **RuboCop Rails Omakase** for consistent Ruby styling
- **Brakeman** for Rails security vulnerability scanning
- **Import Map auditing** for JavaScript dependency security
- GitHub Actions CI pipeline with automated security scans and linting

### Development Tools
- **Docker** support with multi-stage Dockerfile
- **Kamal** for deployment automation
- **Dependabot** for automated dependency updates
- **Ruby 3.4.2** as the target runtime

### Key Configuration Files
- `Procfile.dev` - Defines development processes (server + CSS watching)
- `.rubocop.yml` - Inherits from rails-omakase with extensibility
- `config/routes.rb` - Application routing (currently minimal)
- Solid Queue/Cache/Cable schemas in `db/`

This is a fresh Rails application ready for feature development with modern Rails practices and tooling.