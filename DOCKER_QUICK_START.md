# 🐳 AGSA Docker Quick Reference

## 🚀 **Getting Started (1-2-3 Setup)**

```bash
# 1. Set up environment (interactive)
npm run docker:setup:env

# 2. Build and start everything
npm run docker:setup

# 3. Access your app
# Frontend: http://localhost
# Backend:  http://localhost:8000
# Admin:    http://localhost:8000/admin
```

## 📋 **Essential Commands**

### Production Environment
```bash
npm run docker:build        # Build images
npm run docker:up           # Start services
npm run docker:down         # Stop services
npm run docker:logs         # View all logs
npm run docker:restart      # Restart services
npm run docker:clean        # Clean everything
```

### Development Environment
```bash
npm run docker:dev:up       # Start dev environment
npm run docker:dev:logs     # View dev logs  
npm run docker:dev:down     # Stop dev environment
```

### Service-Specific Logs
```bash
npm run docker:backend:logs  # Backend only
npm run docker:frontend:logs # Frontend only
npm run docker:db:logs       # Database only
```

## 🔧 **Helper Scripts**

### Windows (PowerShell)
```powershell
.\scripts\docker-helper.ps1 setup    # Quick setup
.\scripts\docker-helper.ps1 health   # Health check
.\scripts\docker-helper.ps1 clean    # Clean up
```

### Linux/Mac (Bash)
```bash
./scripts/docker-helper.sh setup     # Quick setup
./scripts/docker-helper.sh health    # Health check
./scripts/docker-helper.sh clean     # Clean up
```

## 🌐 **Access URLs**

| Service | Production | Development |
|---------|------------|-------------|
| Frontend | http://localhost | http://localhost:3001 |
| Backend API | http://localhost:8000 | http://localhost:8001 |
| Admin Panel | http://localhost:8000/admin | http://localhost:8001/admin |
| Database | localhost:5432 | localhost:5433 |
| Redis | localhost:6379 | localhost:6380 |

## 🔑 **Important Files**

- `.env.docker` - Production environment config
- `.env.development` - Development environment config
- `docker-compose.yml` - Production services
- `docker-compose.dev.yml` - Development services
- `docs/DOCKER_SETUP.md` - Full documentation

## 🆘 **Troubleshooting**

```bash
# Check service health
npm run docker:logs

# Restart specific service
docker-compose restart backend

# Clean reset (nuclear option)
npm run docker:clean
npm run docker:build
npm run docker:up
```

## 📝 **Notes**

- Add your Gemini API key to `.env.docker`
- Use development environment for coding
- Production environment for testing deployments
- All data persists in Docker volumes