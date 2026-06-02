#!/bin/bash

# Define your project directory
PROJECT_DIR="/home/victor/mccrudd3n.com"
WEB_ROOT="/var/www/html"

echo "Checking project directory..."

# 1. Check if the project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Directory $PROJECT_DIR not found. Check your path."
    exit 1
fi

# 2. Build the site
echo "Building site..."
cd "$PROJECT_DIR" || exit 1
hugo

# 3. Check if the 'public' folder was actually created
if [ ! -d "$PROJECT_DIR/public" ]; then
    echo "Error: Hugo failed to build the 'public' directory."
    exit 1
fi

# 4. Deploy to Nginx
echo "Deploying to Nginx..."
sudo cp -r "$PROJECT_DIR/public/" "$WEB_ROOT/"

if [ $? -eq 0 ]; then
    echo "Deployment successful!"
else
    echo "Error: Failed to copy files to $WEB_ROOT."
    exit 1
fi
