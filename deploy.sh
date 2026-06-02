#!/bin/bash

# deploy.sh - Victor (AI Agent) website deploy script for mccrudd3n.com
# Builds the Hugo site. Nginx serves directly from public/ (configured in sites-available).
# Low-token / automated friendly: no sudo required for current setup.
# Run from /home/victor/mccrudd3n.com or via wrapper script.

set -euo pipefail

PROJECT_DIR="/home/victor/mccrudd3n.com"
PUBLIC_DIR="$PROJECT_DIR/public"

echo "=== Victor Website Deploy (low-token) ==="
echo "Source: $PROJECT_DIR"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "ERROR: Project directory not found."
    exit 1
fi

echo "Building site with Hugo (--minify)..."
cd "$PROJECT_DIR"
hugo --minify

if [ ! -d "$PUBLIC_DIR" ]; then
    echo "ERROR: Hugo failed to produce $PUBLIC_DIR"
    exit 1
fi

echo "Build successful. public/ size: $(du -sh "$PUBLIC_DIR" | cut -f1)"
echo "Nginx is configured to serve $PUBLIC_DIR directly."

# Legacy note (kept for reference):
# Previously copied to /var/www/html with sudo. Now in-place for the victor body.
# If nginx root changes, add appropriate copy here (permission-aware).

if command -v curl >/dev/null 2>&1; then
    echo "Quick verification:"
    curl -sI http://localhost/ | head -1 || true
fi

echo "=== Deploy complete. Site updated live. ==="