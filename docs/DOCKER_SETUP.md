# 🐳 AGSA Docker Setup & Deployment Guide

Complete guide for deploying AGSA (Automated Government Service Agent) using Docker.

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [📋 Prerequisites](#-prerequisites)
- [⚙️ Environment Configuration](#️-environment-configuration)
- [🏗️ Building & Running](#️-building--running)
- [🔧 Development vs Production](#-development-vs-production)
- [📊 Monitoring & Logs](#-monitoring--logs)
- [🔧 Troubleshooting](#-troubleshooting)
- [🔒 Security Considerations](#-security-considerations)

---

## 🚀 Quick Start

### One-Command Deployment
```bash
# Clone repository
git clone https://github.com/frankmathewsajan/agsa-gov-agent-ai.git
cd agsa-gov-agent-ai

# Interactive setup and deployment
npm run docker:setup:env  # Configure environment
npm run docker:setup      # Build and start everything

# Access your application
# Frontend: http://localhost
# Backend:  http://localhost:8000
# Admin:    http://localhost:8000/admin
```

---

## 📋 Prerequisites

### System Requirements
- **Docker Desktop 4.0+** (Windows/Mac) or Docker Engine 20.0+ (Linux)
- **Docker Compose 2.0+**
- **4GB RAM minimum** (8GB recommended)
- **10GB free disk space**

### Installation
```bash
# Windows/Mac: Download Docker Desktop
# https://www.docker.com/products/docker-desktop

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose-plugin

# CentOS/RHEL
sudo yum install docker docker-compose

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker
```

### Verify Installation
```bash
docker --version          # Should show 20.0+
docker compose version    # Should show 2.0+
docker info               # Should show running status
```

---

## ⚙️ Environment Configuration

### Automatic Setup (Recommended)
```bash
npm run docker:setup:env
```
This interactive script will:
1. Prompt for your Gemini API key
2. Generate secure passwords
3. Create `.env.docker` file
4. Configure all necessary settings

### Manual Setup
```bash
# Copy template
cp .env.docker.template .env.docker

# Edit configuration
nano .env.docker  # Linux/Mac
notepad .env.docker  # Windows
```

### Required Environment Variables
```env
# Essential Configuration
GEMINI_API_KEY=your_gemini_api_key_here  # Get from https://aistudio.google.com/app/apikey
SECRET_KEY=your-secret-key-here
POSTGRES_PASSWORD=your-db-password
REDIS_PASSWORD=your-redis-password

# Optional Configuration
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1,your-domain.com
```

### Getting Gemini API Key
1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with Google account
3. Click "Create API Key"
4. Copy the key (format: `AIza...`)
5. Add to your `.env.docker` file

---

## 🏗️ Building & Running

### Production Deployment
```bash
# Build all services
npm run docker:build
# OR: docker-compose build

# Start services in background
npm run docker:up
# OR: docker-compose up -d

# Initialize database (first time only)
docker-compose exec backend uv run python manage.py migrate
docker-compose exec backend uv run python manage.py createsuperuser
```

### Development Environment
```bash
# Start development services
npm run docker:dev:up
# OR: docker-compose -f docker-compose.dev.yml up -d

# Services run on different ports
# Backend: http://localhost:8001
# Database: localhost:5433
# Redis: localhost:6380
```

### Service Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │    Backend      │    │   Database      │
│   (nginx)       │◄──►│   (Django)      │◄──►│ (PostgreSQL)    │
│   Port: 80      │    │   Port: 8000    │    │   Port: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └─────────────┬─────────────────┬─────────────────┘
                       │                 │
              ┌─────────▼─────────┐      ┌▼─────────────────┐
              │      Redis        │      │    Volumes       │
              │   (Sessions)      │      │  (Persistent)    │
              │   Port: 6379      │      │     Data         │
              └───────────────────┘      └──────────────────┘
```

---

## 🔧 Development vs Production

### Development Environment Features
- **Hot Reload**: Code changes reflect immediately
- **Debug Mode**: Detailed error messages
- **Development Ports**: Non-conflicting port assignments
- **Volume Mounts**: Source code mounted for live editing
- **Relaxed Security**: Easier development and testing

#### Development Ports
| Service | Port | Access URL |
|---------|------|------------|
| Frontend | 3001 | http://localhost:3001 |
| Backend | 8001 | http://localhost:8001 |
| Database | 5433 | localhost:5433 |
| Redis | 6380 | localhost:6380 |

### Production Environment Features
- **Performance Optimized**: Production builds and configurations
- **Security Hardened**: Secure headers, non-root users
- **Standard Ports**: Conventional port assignments
- **Persistent Volumes**: Data survives container restarts
- **Health Checks**: Automatic service monitoring

#### Production Ports
| Service | Port | Access URL |
|---------|------|------------|
| Frontend | 80 | http://localhost |
| Backend | 8000 | http://localhost:8000 |
| Database | 5432 | localhost:5432 |
| Redis | 6379 | localhost:6379 |

---

## 📊 Monitoring & Logs

### View Logs
```bash
# All services
npm run docker:logs
# OR: docker-compose logs -f

# Specific service
npm run docker:backend:logs    # Backend only
npm run docker:frontend:logs   # Frontend only
npm run docker:db:logs         # Database only

# Follow logs in real-time
docker-compose logs -f --tail=100 backend
```

### Health Checks
```bash
# Check service status
docker-compose ps

# Manual health check
curl http://localhost:8000/api/health/  # Backend
curl http://localhost/health            # Frontend

# Service health status
docker-compose exec backend uv run python manage.py check
```

### Resource Monitoring
```bash
# Resource usage
docker stats

# Disk usage
docker system df

# Container inspection
docker-compose exec backend env  # Environment variables
docker-compose exec database psql -U agsa_user -d agsa_db -c '\dt'  # Database tables
```

---

## 🔧 Troubleshooting

### Common Issues & Solutions

#### Port Already in Use
```bash
# Find process using port
netstat -tulpn | grep :80    # Linux
lsof -i :80                  # Mac
netstat -ano | findstr :80   # Windows

# Stop existing process or change port
docker-compose down
# Edit docker-compose.yml ports section
```

#### Database Connection Issues
```bash
# Check database status
docker-compose exec database pg_isready -U agsa_user

# Reset database
docker-compose down -v  # Warning: Deletes all data
docker-compose up -d database
docker-compose exec backend uv run python manage.py migrate
```

#### Permission Errors
```bash
# Fix permissions (Linux/Mac)
sudo chown -R $USER:$USER .
chmod +x scripts/*.sh

# Windows: Run as Administrator
# Or use Docker Desktop settings to allow bind mounts
```

#### Out of Memory
```bash
# Increase Docker memory (Docker Desktop)
# Settings > Resources > Memory > 4GB+

# Clean unused Docker resources
docker system prune -a
docker volume prune
```

#### SSL/Certificate Errors
```bash
# Disable SSL verification for development
export PYTHONHTTPSVERIFY=0

# Update certificates
docker-compose build --no-cache
```

### Service-Specific Debugging

#### Backend Issues
```bash
# Django shell
docker-compose exec backend uv run python manage.py shell

# Check migrations
docker-compose exec backend uv run python manage.py showmigrations

# Collect static files
docker-compose exec backend uv run python manage.py collectstatic --noinput

# Test Gemini API
docker-compose exec backend uv run python -c "
import os
import google.generativeai as genai
genai.configure(api_key=os.getenv('GEMINI_API_KEY'))
model = genai.GenerativeModel('gemini-1.5-flash')
print(model.generate_content('Hello').text)
"
```

#### Frontend Issues
```bash
# Check nginx configuration
docker-compose exec frontend nginx -t

# View nginx error logs
docker-compose logs frontend

# Access container
docker-compose exec frontend sh
```

#### Database Issues
```bash
# Database shell
docker-compose exec database psql -U agsa_user -d agsa_db

# Check database size
docker-compose exec database psql -U agsa_user -d agsa_db -c "
SELECT schemaname,tablename,attname,n_distinct,correlation 
FROM pg_stats WHERE schemaname='public';
"

# Backup database
docker-compose exec database pg_dump -U agsa_user agsa_db > backup.sql
```

### Complete Reset (Nuclear Option)
```bash
# Stop everything and clean
npm run docker:clean
# OR: 
docker-compose down -v --remove-orphans
docker system prune -a
docker volume prune

# Rebuild from scratch
npm run docker:build
npm run docker:up
```

---

## 🔒 Security Considerations

### Production Security Checklist
- [ ] **Strong passwords** for database and Redis
- [ ] **Secure SECRET_KEY** (50+ random characters)
- [ ] **HTTPS enabled** for production domains
- [ ] **Firewall configured** to block unnecessary ports
- [ ] **Regular updates** of base images and dependencies
- [ ] **Backup strategy** for persistent data
- [ ] **Monitoring** and alerting configured

### Environment Variables Security
```bash
# Never commit .env files to git
echo ".env*" >> .gitignore

# Use Docker secrets for production
docker secret create gemini_api_key gemini_key.txt
```

### Network Security
```bash
# Production: Use external network
# docker-compose.yml
networks:
  agsa_network:
    external: true
    name: production_network
```

### Data Persistence & Backups
```bash
# Backup volumes
docker run --rm -v agsa_postgres_data:/data -v $(pwd):/backup ubuntu tar czf /backup/postgres_backup.tar.gz /data

# Restore volumes
docker run --rm -v agsa_postgres_data:/data -v $(pwd):/backup ubuntu tar xzf /backup/postgres_backup.tar.gz -C /data --strip 1
```

### Resource Limits
```yaml
# docker-compose.yml
services:
  backend:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
        reservations:
          memory: 256M
```

---

## 🎯 Performance Optimization

### Production Optimization
- **Enable gzip compression** in nginx
- **Use Redis caching** for database queries
- **Optimize static file serving**
- **Configure database connection pooling**
- **Enable Docker BuildKit** for faster builds

### Build Optimization
```bash
# Use build cache
DOCKER_BUILDKIT=1 docker-compose build

# Multi-platform builds
docker buildx build --platform linux/amd64,linux/arm64 .
```

---

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Django Production Deployment](https://docs.djangoproject.com/en/5.2/howto/deployment/)
- [React Production Builds](https://vitejs.dev/guide/build.html)
- [PostgreSQL Docker](https://hub.docker.com/_/postgres)
- [Redis Docker](https://hub.docker.com/_/redis)

---

**Need Help?** 
- Check [GitHub Issues](https://github.com/frankmathewsajan/agsa-gov-agent-ai/issues)
- Review [Troubleshooting Section](#-troubleshooting)
- Join [GitHub Discussions](https://github.com/frankmathewsajan/agsa-gov-agent-ai/discussions)