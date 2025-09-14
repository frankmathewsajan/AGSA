# AGSA Docker Development Helper Scripts for Windows
# PowerShell version

param(
    [Parameter(Position=0)]
    [string]$Command = "help",
    
    [Parameter(Position=1)]
    [string]$Service = ""
)

# Colors for output
function Write-Status {
    param([string]$Message)
    Write-Host "[AGSA] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[AGSA] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[AGSA] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[AGSA] $Message" -ForegroundColor Red
}

# Check if Docker is running
function Test-Docker {
    try {
        docker info | Out-Null
        return $true
    }
    catch {
        Write-Error "Docker is not running. Please start Docker Desktop."
        exit 1
    }
}

# Quick setup for development
function Start-QuickSetup {
    Write-Status "🚀 Quick setup for AGSA development environment..."
    
    Test-Docker
    
    # Copy environment file if it doesn't exist
    if (-not (Test-Path ".env.docker")) {
        if (Test-Path ".env.docker.template") {
            Write-Warning "Creating .env.docker from template..."
            Copy-Item ".env.docker.template" ".env.docker"
            Write-Warning "⚠️  Please edit .env.docker and add your Gemini API key!"
        }
        else {
            Write-Error ".env.docker.template not found!"
            exit 1
        }
    }
    
    Write-Status "Building Docker images..."
    docker-compose build
    
    Write-Status "Starting services..."
    docker-compose up -d
    
    Write-Status "Waiting for services to be ready..."
    Start-Sleep -Seconds 10
    
    Write-Status "Running database migrations..."
    docker-compose exec backend uv run python manage.py migrate
    
    Write-Status "Creating superuser (optional)..."
    docker-compose exec backend uv run python manage.py createsuperuser --noinput --email admin@example.com --username admin
    
    Write-Success "✅ Setup complete!"
    Write-Success "🌐 Frontend: http://localhost"
    Write-Success "🔧 Backend API: http://localhost:8000"
    Write-Success "📊 Admin: http://localhost:8000/admin"
}

# Development setup
function Start-DevSetup {
    Write-Status "🛠️  Setting up development environment..."
    
    Test-Docker
    
    Write-Status "Building development containers..."
    docker-compose -f docker-compose.dev.yml build
    
    Write-Status "Starting development services..."
    docker-compose -f docker-compose.dev.yml up -d
    
    Write-Status "Running migrations..."
    docker-compose -f docker-compose.dev.yml exec backend uv run python manage.py migrate
    
    Write-Success "✅ Development environment ready!"
    Write-Success "🔧 Backend: http://localhost:8001"
    Write-Success "🗄️  Database: localhost:5433"
    Write-Success "🔴 Redis: localhost:6380"
}

# Clean everything
function Start-CleanAll {
    Write-Warning "🧹 Cleaning up Docker environment..."
    
    Write-Status "Stopping all containers..."
    docker-compose down
    docker-compose -f docker-compose.dev.yml down
    
    Write-Status "Removing volumes..."
    docker-compose down -v
    docker-compose -f docker-compose.dev.yml down -v
    
    Write-Status "Removing orphaned containers..."
    docker system prune -f
    
    Write-Success "✅ Cleanup complete!"
}

# Show logs
function Show-Logs {
    param([string]$ServiceName)
    
    if ([string]::IsNullOrEmpty($ServiceName)) {
        Write-Status "📋 Showing all logs..."
        docker-compose logs -f
    }
    else {
        Write-Status "📋 Showing logs for $ServiceName..."
        docker-compose logs -f $ServiceName
    }
}

# Health check
function Test-Health {
    Write-Status "🏥 Checking service health..."
    
    Write-Host ""
    Write-Status "Backend Health:"
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8000/api/health/" -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Success "✅ Backend OK"
        }
        else {
            Write-Error "❌ Backend Failed"
        }
    }
    catch {
        Write-Error "❌ Backend Failed"
    }
    
    Write-Host ""
    Write-Status "Frontend Health:"
    try {
        $response = Invoke-WebRequest -Uri "http://localhost/health" -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Success "✅ Frontend OK"
        }
        else {
            Write-Error "❌ Frontend Failed"
        }
    }
    catch {
        Write-Error "❌ Frontend Failed"
    }
    
    Write-Host ""
    Write-Status "Database Health:"
    try {
        docker-compose exec database pg_isready -U agsa_user
        Write-Success "✅ Database OK"
    }
    catch {
        Write-Error "❌ Database Failed"
    }
}

# Show help
function Show-Help {
    Write-Host "AGSA Docker Helper Scripts for Windows"
    Write-Host "======================================"
    Write-Host ""
    Write-Host "Usage: .\scripts\docker-helper.ps1 [command] [service]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  setup     - Quick production setup"
    Write-Host "  dev       - Development environment setup"
    Write-Host "  clean     - Clean all Docker resources"
    Write-Host "  logs      - Show logs (optional: service name)"
    Write-Host "  health    - Check service health"
    Write-Host "  help      - Show this help"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\scripts\docker-helper.ps1 setup"
    Write-Host "  .\scripts\docker-helper.ps1 logs backend"
    Write-Host "  .\scripts\docker-helper.ps1 health"
}

# Main script logic
switch ($Command.ToLower()) {
    "setup" {
        Start-QuickSetup
    }
    "dev" {
        Start-DevSetup
    }
    "clean" {
        Start-CleanAll
    }
    "logs" {
        Show-Logs -ServiceName $Service
    }
    "health" {
        Test-Health
    }
    default {
        Show-Help
    }
}