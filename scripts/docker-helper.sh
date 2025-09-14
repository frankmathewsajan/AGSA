#!/bin/bash

# AGSA Docker Development Helper Scripts
# Use these commands for common Docker operations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[AGSA]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[AGSA]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[AGSA]${NC} $1"
}

print_error() {
    echo -e "${RED}[AGSA]${NC} $1"
}

# Check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
}

# Quick setup for development
quick_setup() {
    print_status "🚀 Quick setup for AGSA development environment..."
    
    check_docker
    
    # Copy environment file if it doesn't exist
    if [ ! -f .env.docker ]; then
        if [ -f .env.docker.template ]; then
            print_warning "Creating .env.docker from template..."
            cp .env.docker.template .env.docker
            print_warning "⚠️  Please edit .env.docker and add your Gemini API key!"
        else
            print_error ".env.docker.template not found!"
            exit 1
        fi
    fi
    
    print_status "Building Docker images..."
    docker-compose build
    
    print_status "Starting services..."
    docker-compose up -d
    
    print_status "Waiting for services to be ready..."
    sleep 10
    
    print_status "Running database migrations..."
    docker-compose exec backend uv run python manage.py migrate
    
    print_status "Creating superuser (optional)..."
    docker-compose exec backend uv run python manage.py createsuperuser --noinput --email admin@example.com --username admin || true
    
    print_success "✅ Setup complete!"
    print_success "🌐 Frontend: http://localhost"
    print_success "🔧 Backend API: http://localhost:8000"
    print_success "📊 Admin: http://localhost:8000/admin"
}

# Development setup
dev_setup() {
    print_status "🛠️  Setting up development environment..."
    
    check_docker
    
    print_status "Building development containers..."
    docker-compose -f docker-compose.dev.yml build
    
    print_status "Starting development services..."
    docker-compose -f docker-compose.dev.yml up -d
    
    print_status "Running migrations..."
    docker-compose -f docker-compose.dev.yml exec backend uv run python manage.py migrate
    
    print_success "✅ Development environment ready!"
    print_success "🔧 Backend: http://localhost:8001"
    print_success "🗄️  Database: localhost:5433"
    print_success "🔴 Redis: localhost:6380"
}

# Clean everything
clean_all() {
    print_warning "🧹 Cleaning up Docker environment..."
    
    print_status "Stopping all containers..."
    docker-compose down
    docker-compose -f docker-compose.dev.yml down
    
    print_status "Removing volumes..."
    docker-compose down -v
    docker-compose -f docker-compose.dev.yml down -v
    
    print_status "Removing orphaned containers..."
    docker system prune -f
    
    print_success "✅ Cleanup complete!"
}

# Show logs
show_logs() {
    local service=${1:-""}
    
    if [ -z "$service" ]; then
        print_status "📋 Showing all logs..."
        docker-compose logs -f
    else
        print_status "📋 Showing logs for $service..."
        docker-compose logs -f "$service"
    fi
}

# Health check
health_check() {
    print_status "🏥 Checking service health..."
    
    echo ""
    print_status "Backend Health:"
    curl -f http://localhost:8000/api/health/ && print_success "✅ Backend OK" || print_error "❌ Backend Failed"
    
    echo ""
    print_status "Frontend Health:"
    curl -f http://localhost/health && print_success "✅ Frontend OK" || print_error "❌ Frontend Failed"
    
    echo ""
    print_status "Database Health:"
    docker-compose exec database pg_isready -U agsa_user && print_success "✅ Database OK" || print_error "❌ Database Failed"
}

# Show help
show_help() {
    echo "AGSA Docker Helper Scripts"
    echo "========================="
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  setup     - Quick production setup"
    echo "  dev       - Development environment setup"
    echo "  clean     - Clean all Docker resources"
    echo "  logs      - Show logs (optional: service name)"
    echo "  health    - Check service health"
    echo "  help      - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 setup"
    echo "  $0 logs backend"
    echo "  $0 health"
}

# Main script logic
case "${1:-help}" in
    "setup")
        quick_setup
        ;;
    "dev")
        dev_setup
        ;;
    "clean")
        clean_all
        ;;
    "logs")
        show_logs "$2"
        ;;
    "health")
        health_check
        ;;
    "help"|*)
        show_help
        ;;
esac