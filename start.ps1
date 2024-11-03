# Change to the project directory
Set-Location "C:\Users\colin\Documents\DiscordAIAssistant" # Remember to change this directory to your local repo location!!

# Stop and remove any orphaned or running containers
Write-Host "Stopping and removing existing containers..." -ForegroundColor Yellow
docker-compose down --remove-orphans

# Clean up unused Docker networks and volumes
Write-Host "Pruning Docker networks and volumes..." -ForegroundColor Yellow
docker network prune -f
docker volume prune -f

# Rebuild and start the containers
Write-Host "Building and starting the containers..." -ForegroundColor Yellow
docker-compose build --no-cache
docker-compose up -d

# Wait for containers to initialize
Start-Sleep -Seconds 5

# Check the status of all containers
Write-Host "Checking container statuses..." -ForegroundColor Cyan
docker ps -a

# Open logs in a new Command Prompt
Start-Process "cmd.exe" "/k docker logs -f discordaiassistant-mongodb-1"
Start-Process "cmd.exe" "/k docker logs -f discordaiassistant-api-application-1"
Start-Process "cmd.exe" "/k docker logs -f discordaiassistant-discord-bot-1"

# Check MongoDB health status
Write-Host "Checking MongoDB health..." -ForegroundColor Yellow
$health = docker inspect --format "{{json .State.Health }}" discordaiassistant-mongodb-1 | ConvertFrom-Json

if ($health.Status -eq "unhealthy") {
    Write-Host "MongoDB container is unhealthy. Check logs and health checks." -ForegroundColor Red
} else {
    Write-Host "All containers are healthy and running!" -ForegroundColor Green
}
