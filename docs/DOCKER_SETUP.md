# 🐳 Docker Setup for AGSA Government Agent AI

This document provides complete instructions for setting up and running the AGSA Government Agent AI application using Docker.

## 📋 Prerequisites

- **Docker Desktop** 4.0+ installed and running
- **Docker Compose** v2.0+ (included with Docker Desktop)
- **Node.js** 18+ (for development scripts)
- **Git** (for cloning the repository)

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)

```bash
# 1. Clone and navigate to the project
git clone <repository-url>
cd agsa-gov-agent-ai

# 2. Run automated setup
npm run docker:setup:env
npm run docker:setup

# 3. Access the application
# Frontend: http://localhost
# Backend API: http://localhost:8000
# Admin Panel: http://localhost:8000/admin
```

### Option 2: Manual Setup

```bash
# 1. Create environment file
cp .env.docker.template .env.docker

# 2. Edit .env.docker and add your configuration
# - Add your Gemini API key
# - Set secure passwords for database and Redis
# - Configure domain settings for production

# 3. Build and start services
docker-compose build
docker-compose up -d

# 4. Run database migrations
docker-compose exec backend uv run python manage.py migrate

# 5. Create admin user (optional)
docker-compose exec backend uv run python manage.py createsuperuser
```

## 🏗️ Architecture Overview

The Docker setup includes the following services:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │    Backend      │    │   Database      │
│   (React)       │    │   (Django)      │    │  (PostgreSQL)   │
│   Port: 80      │────│   Port: 8000    │────│   Port: 5432    │
│   nginx         │    │   Python 3.11   │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                       ┌─────────────────┐
                       │     Redis       │
                       │   (Cache)       │
                       │   Port: 6379    │
                       └─────────────────┘
```

## 📁 Docker Files Structure

```
├── Dockerfile                 # Frontend Docker image
├── backend/
│   └── Dockerfile            # Backend Docker image
├── docker-compose.yml        # Production configuration
├── docker-compose.dev.yml    # Development configuration
├── nginx.conf               # Nginx configuration for frontend
├── .env.docker.template     # Environment template
├── .env.development         # Development environment
└── scripts/
    ├── docker-helper.sh     # Linux/Mac helper scripts
    ├── docker-helper.ps1    # Windows PowerShell scripts
    ├── setup-docker-env.js  # Environment setup utility
    └── init-db.sql          # Database initialization
```

## 🛠️ Development Workflow

### Development Environment

For development with hot reload and debugging:

```bash
# Start development environment
npm run docker:dev:up

# View logs
npm run docker:dev:logs

# Stop development environment
npm run docker:dev:down
```

**Development URLs:**
- Backend: http://localhost:8001
- Database: localhost:5433
- Redis: localhost:6380

### Production Environment

For production-like testing:

```bash
# Start production environment
npm run docker:up

# View logs
npm run docker:logs

# Stop production environment
npm run docker:down
```

## 🔧 Configuration

### Environment Variables

Key environment variables in `.env.docker`:

```bash
# Security
SECRET_KEY=your-secret-key-here
DEBUG=False

# Database
POSTGRES_DB=agsa_db
POSTGRES_USER=agsa_user
POSTGRES_PASSWORD=your-db-password

# Redis
REDIS_PASSWORD=your-redis-password

# AI Service
GEMINI_API_KEY=your-gemini-api-key

# Domain (for production)
ALLOWED_HOSTS=localhost,127.0.0.1,your-domain.com
```

### Database Configuration

The PostgreSQL database is automatically configured with:
- **Database**: `agsa_db`
- **User**: `agsa_user` 
- **Port**: 5432 (internal), 5432 (host)
- **Persistent storage** via Docker volumes

### Redis Configuration

Redis is used for:
- Session storage
- Caching AI responses
- Background task queues

## 📊 Monitoring and Debugging

### Health Checks

All services include health checks:

```bash
# Check all services
./scripts/docker-helper.sh health

# Or using PowerShell on Windows
.\scripts\docker-helper.ps1 health
```

### Viewing Logs

```bash
# All services
npm run docker:logs

# Specific service
npm run docker:backend:logs
npm run docker:frontend:logs
npm run docker:db:logs

# Follow logs in real-time
docker-compose logs -f
```

### Service Status

```bash
# Check running containers
docker-compose ps

# Check resource usage
docker stats
```

## 🔒 Security Features

### Container Security
- Non-root users in all containers
- Read-only filesystems where possible
- Resource limits and health checks
- Minimal base images (Alpine Linux)

### Network Security
- Internal Docker network isolation
- Only necessary ports exposed
- Secure headers in nginx configuration

### Data Security
- Environment variables for secrets
- Encrypted connections between services
- Persistent data in named volumes

## 🚢 Deployment

### Production Deployment

1. **Prepare Environment**:
   ```bash
   # Copy and customize environment
   cp .env.docker.template .env.docker
   # Edit .env.docker with production values
   ```

2. **Security Settings**:
   ```bash
   # In .env.docker, set:
   DEBUG=False
   SECURE_SSL_REDIRECT=True
   SESSION_COOKIE_SECURE=True
   CSRF_COOKIE_SECURE=True
   ```

3. **Deploy**:
   ```bash
   docker-compose up -d
   ```

### Scaling

Scale specific services:

```bash
# Scale backend instances
docker-compose up -d --scale backend=3

# Scale with load balancer (requires additional configuration)
docker-compose -f docker-compose.yml -f docker-compose.scale.yml up -d
```

## 🧹 Maintenance

### Backup Database

```bash
# Create backup
docker-compose exec database pg_dump -U agsa_user agsa_db > backup.sql

# Restore backup
docker-compose exec -T database psql -U agsa_user agsa_db < backup.sql
```

### Update Images

```bash
# Pull latest images
docker-compose pull

# Rebuild and restart
docker-compose up -d --build
```

### Clean Up

```bash
# Stop and remove containers, networks, volumes
npm run docker:clean

# Or manually
docker-compose down -v --remove-orphans
docker system prune -f
```

## 🔧 Troubleshooting

### Common Issues

1. **Port Conflicts**:
   ```bash
   # Change ports in .env.docker
   BACKEND_PORT=8001
   FRONTEND_PORT=8080
   ```

2. **Database Connection Issues**:
   ```bash
   # Check database logs
   docker-compose logs database
   
   # Restart database
   docker-compose restart database
   ```

3. **Memory Issues**:
   ```bash
   # Increase Docker memory limit in Docker Desktop
   # Or add memory limits to docker-compose.yml
   ```

4. **Permission Issues**:
   ```bash
   # On Linux, fix file permissions
   sudo chown -R $USER:$USER .
   ```

### Debug Mode

Enable debug mode for troubleshooting:

```bash
# In .env.docker
DEBUG=True
LOG_LEVEL=DEBUG

# Restart services
docker-compose restart
```

### Logs Location

- **Application logs**: Available via `docker-compose logs`
- **Nginx logs**: `/var/log/nginx/` in frontend container
- **Database logs**: Available via `docker-compose logs database`

## 📚 Additional Resources

### Useful Commands

```bash
# Enter container shell
docker-compose exec backend bash
docker-compose exec frontend sh

# Run Django commands
docker-compose exec backend uv run python manage.py migrate
docker-compose exec backend uv run python manage.py collectstatic

# Database operations
docker-compose exec database psql -U agsa_user agsa_db
```

### Performance Optimization

1. **Enable Gzip** (already configured in nginx)
2. **Use Redis caching** (configured)
3. **Optimize Docker images** (multi-stage builds used)
4. **Resource limits** (can be added to docker-compose.yml)

### Development Tips

- Use `docker-compose.dev.yml` for development
- Mount source code volumes for hot reload
- Use separate databases for development and production
- Enable debug mode only in development

## 🆘 Support

If you encounter issues:

1. Check the logs: `npm run docker:logs`
2. Verify configuration: Review `.env.docker`
3. Check Docker resources: `docker system df`
4. Restart services: `npm run docker:restart`
5. Clean reset: `npm run docker:clean` then rebuild

For additional help, refer to the main project documentation or create an issue in the repository.