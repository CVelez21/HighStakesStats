#!/bin/bash

# Function to handle cleanup when stopping the script
cleanup() {
    echo "Stopping the applications..."
    kill "$BACKEND_PID" "$FRONTEND_PID" 2>/dev/null
    wait "$BACKEND_PID" "$FRONTEND_PID" 2>/dev/null
    echo "Applications stopped."
}

# Trap SIGINT and SIGTERM to call cleanup function on script exit
trap cleanup SIGINT SIGTERM

# Detect the project root using .project-root marker file
find_project_root() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.project-root" ]]; then
            echo "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done
    echo "Error: Project root marker (.project-root) not found. Exiting."
    exit 1
}

# Define global paths
PROJECT_ROOT=$(find_project_root)
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"
LOGS_DIR="$PROJECT_ROOT/Logs"

# Create the logs folder if it doesn't exist
if [ ! -d "$LOGS_DIR" ]; then
    mkdir "$LOGS_DIR"
    echo "Created logs directory: $LOGS_DIR"
fi

# Navigate to the backend directory and start the Spring Boot application in the testing environment
if [ -d "$BACKEND_DIR" ]; then
    cd "$BACKEND_DIR" || exit 1
else
    echo "Backend directory not found: $BACKEND_DIR. Exiting."
    exit 1
fi

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "Maven is not installed. Please install Maven and try again."
    exit 1
fi

# Start the backend with Maven, using the 'test' profile
echo "Starting the Spring Boot backend in the testing environment..."
mvn spring-boot:run -Dspring-boot.run.profiles=test > "$LOGS_DIR/backendH2.log" 2>&1 &
BACKEND_PID=$!
echo "Backend is running with PID: $BACKEND_PID. Logs are available in $LOGS_DIR/backendH2.log."

# Navigate back to the frontend directory
if [ -d "$FRONTEND_DIR" ]; then
    cd "$FRONTEND_DIR" || exit 1
else
    echo "Frontend directory not found: $FRONTEND_DIR. Exiting."
    kill "$BACKEND_PID"
    exit 1
fi

# Check if Node.js is installed
if ! command -v npm &> /dev/null; then
    echo "Node.js (npm) is not installed. Please install Node.js and try again."
    kill "$BACKEND_PID"
    exit 1
fi

# Start the frontend with npm
echo "Starting the React frontend..."
npm start > "$LOGS_DIR/frontendH2.log" 2>&1 &
FRONTEND_PID=$!
echo "Frontend is running with PID: $FRONTEND_PID. Logs are available in $LOGS_DIR/frontendH2.log."

# Wait for both processes to exit
wait "$BACKEND_PID" "$FRONTEND_PID"