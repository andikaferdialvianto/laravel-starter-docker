#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Define animation frames
FRAMES=("🌤" "🌥" "⛅️" "🌦" "🌧" "🌧" "🌨" "🌨" "❄️" "❄️" "🌧" "🌧" "🌨" "🌨" "❄️" "❄️")

# Function to display an animation
animate() {
  local i=0
  while true; do
    printf "\r[${FRAMES[i]}] ${1}"
    sleep 0.2
    i=$(( (i+1) % ${#FRAMES[@]} ))
  done
}

# Deploy animation
deploy_animation() {
  animate "${YELLOW}Deploying Laravel Starter Docker...${NC}"
}

# Clone the repository
git clone https://github.com/andikaferdialvianto/laravel-starter-docker.git laravel-starter-docker

# Navigate to the cloned directory
cd laravel-starter-docker

# Build the Docker image
deploy_animation &
animation_pid=$!
docker build -t laravel-starter-app .
kill -9 $animation_pid > /dev/null 2>&1

# Run the Docker container
docker run -d -p 8000:80 --name laravel-starter-container laravel-starter-app

echo -e "\n${GREEN}Laravel Starter Docker application has been deployed!${NC}"
echo -e "${CYAN}Access the application at: http://localhost:8000${NC}"
