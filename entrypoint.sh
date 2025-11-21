#!/bin/bash

# ClassRoom Hero - Complete Startup Script
# This script starts all services for the application

set -e

app_env=${1:-development}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GROWARK_DIR="${PROJECT_ROOT}/growark"

echo "================================================"
echo "ClassRoom Hero - Application Startup"
echo "Environment: ${app_env}"
echo "Project Root: ${PROJECT_ROOT}"
echo "================================================"
echo ""

# Function to check if port is available
check_port() {
    local port=$1
    if netstat -tlnp 2>/dev/null | grep -q ":$port " || ss -tlnp 2>/dev/null | grep -q ":$port"; then
        return 1  # Port in use
    else
        return 0  # Port available
    fi
}

# Development environment setup
dev_commands() {
    echo "🚀 Starting in DEVELOPMENT mode..."
    echo ""

    # Navigate to growark directory
    cd "${GROWARK_DIR}"

    # Install dependencies if needed
    if [ ! -d "node_modules" ]; then
        echo "📦 Installing dependencies..."
        npm install
    fi

    echo "✓ Dependencies ready"
    echo ""

    # Start services in background
    echo "🔄 Starting services..."

    # 1. Start mobile admin backend on port 5000 (Vite dev server)
    echo "  ➜ Mobile Admin (Port 5000)..."
    npm run dev -- --port 5000 > "${PROJECT_ROOT}/.logs/dev-5000.log" 2>&1 &
    DEV_PID=$!
    echo "  ✓ Started (PID: $DEV_PID)"

    # Wait for Vite server to be ready
    sleep 5

    # 2. Start bigscreen on port 3000
    echo "  ➜ BigScreen Display (Port 3000)..."
    PORT=3000 node bigscreen/preview-server.js > "${PROJECT_ROOT}/.logs/bigscreen-3000.log" 2>&1 &
    BIGSCREEN_PID=$!
    echo "  ✓ Started (PID: $BIGSCREEN_PID)"

    echo ""
    echo "================================================"
    echo "✅ All services started successfully!"
    echo "================================================"
    echo ""
    echo "📱 Mobile Admin Backend:"
    echo "   Local: http://localhost:5000"
    echo "   Dev:   http://0.0.0.0:5000"
    echo ""
    echo "🖥️  BigScreen Display:"
    echo "   Local: http://localhost:3000"
    echo "   Dev:   http://0.0.0.0:3000"
    echo ""
    echo "📝 Logs:"
    echo "   Mobile:    ${PROJECT_ROOT}/.logs/dev-5000.log"
    echo "   BigScreen: ${PROJECT_ROOT}/.logs/bigscreen-3000.log"
    echo ""
    echo "Press Ctrl+C to stop all services"
    echo "================================================"
    echo ""

    # Keep the script running and forward signals to child processes
    trap "kill $DEV_PID $BIGSCREEN_PID 2>/dev/null; exit 0" SIGINT SIGTERM
    wait
}

# Production environment setup
prod_commands() {
    echo "🚀 Starting in PRODUCTION mode..."
    echo ""

    cd "${GROWARK_DIR}"

    # Build if needed
    if [ ! -d "dist" ]; then
        echo "📦 Building application..."
        npm run build
    fi

    echo "✓ Build ready"
    echo ""

    # Start services in background
    echo "🔄 Starting services..."

    # 1. Start Express server on port 8080 (serves both apps)
    echo "  ➜ Express Server (Port 8080)..."
    NODE_ENV=production node server/server.js > "${PROJECT_ROOT}/.logs/server-8080.log" 2>&1 &
    SERVER_PID=$!
    echo "  ✓ Started (PID: $SERVER_PID)"

    # Wait for server to be ready
    sleep 3

    # 2. Start bigscreen preview on port 5000
    echo "  ➜ BigScreen Display (Port 5000)..."
    PORT=5000 node bigscreen/preview-server.js > "${PROJECT_ROOT}/.logs/bigscreen-5000.log" 2>&1 &
    BIGSCREEN_PID=$!
    echo "  ✓ Started (PID: $BIGSCREEN_PID)"

    echo ""
    echo "================================================"
    echo "✅ All services started successfully!"
    echo "================================================"
    echo ""
    echo "📱 Mobile Admin Backend:"
    echo "   URL: http://0.0.0.0:8080"
    echo ""
    echo "🖥️  BigScreen Display:"
    echo "   URL: http://0.0.0.0:5000"
    echo ""
    echo "📝 Logs:"
    echo "   Server:    ${PROJECT_ROOT}/.logs/server-8080.log"
    echo "   BigScreen: ${PROJECT_ROOT}/.logs/bigscreen-5000.log"
    echo ""
    echo "Press Ctrl+C to stop all services"
    echo "================================================"
    echo ""

    # Keep the script running and forward signals to child processes
    trap "kill $SERVER_PID $BIGSCREEN_PID 2>/dev/null; exit 0" SIGINT SIGTERM
    wait
}

# Create logs directory
mkdir -p "${PROJECT_ROOT}/.logs"

# Check environment and run appropriate commands
if [ "$app_env" = "production" ] || [ "$app_env" = "prod" ]; then
    prod_commands
else
    dev_commands
fi
