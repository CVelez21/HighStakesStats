#!/bin/bash

# Global variable to store summary report
SUMMARY_REPORT=()

# Function to add a message to the summary report
add_to_summary() {
    local message=$1
    SUMMARY_REPORT+=("$message")
}

# Function to display the summary report at the end
summary_report() {
    echo ""
    echo ""
    echo ""
    echo "========================================================================================"
    echo "Setup Summary Report:"
    echo "========================================================================================"
    for message in "${SUMMARY_REPORT[@]}"; do
        echo "- $message"
    done
    echo "========================================================================================"
    exit "$1"
}

# Function to find the project root directory using the .project-root marker file
find_project_root() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.project-root" ]]; then
            echo "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done

    # Custom error message based on the detected OS
    echo "Error: Project root marker (.project-root) not found."
    echo ""
    echo "Please ensure the following:"
    echo "1. The .project-root file exists in the repository."
    echo "2. The file is readable. If not, adjust permissions using the following commands:"
    echo ""

    # Use the detected OS to provide specific instructions
    if [[ "$OS" == "mac" || "$OS" == "linux" ]]; then
        echo "   On macOS/Linux:"
        echo "       chmod 644 .project-root"
    elif [[ "$OS" == "windows" ]]; then
        echo "   On Windows:"
        echo "       icacls .project-root /grant %USERNAME%:R"
    else
        echo "   Please check your system's documentation to adjust file permissions."
    fi

    echo ""
    echo "After verifying these steps, rerun the script."
    add_to_summary ".project-root file not found"
    summary_report 1
}

# Function to detect the operating system and set a global variable
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="mac"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
        OS="windows"
    else
        add_to_summary "Unsupported operating system detected: $OSTYPE"
        summary_report 1
    fi
}

# Function to ask the user if they want to install a missing dependency
ask_to_install() {
    local dependency=$1
    local install_command=$2
    local check_command=$3

    read -p "$dependency is not installed. Do you want to install it using Homebrew? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        # Check if Homebrew is installed, since it's needed for installation
        if ! command -v brew &> /dev/null; then
            echo "Homebrew is not installed, which is required for installing $dependency. Please install Homebrew from https://brew.sh and rerun the script."
            add_to_summary "Homebrew not installed"
            summary_report 1
        fi

        echo "Attempting to install $dependency with Homebrew..."
        eval "$install_command"

        # Confirm the installation
        if ! command -v $check_command &> /dev/null; then
            echo "$dependency installation failed or is not accessible. Please install it manually and rerun the script."
            add_to_summary "Dependency Failed to install"
            summary_report 1
        else
            echo "$dependency was installed successfully."
            add_to_summary "$dependency was installed successfully."
        fi
    else
        echo "$dependency is required to continue. Exiting script."
        add_to_summary "Missing Dependency"
        summary_report 1
    fi
}

# Function to create the .env files for both backend and frontend
create_env_files() {
    # Create backend .env file
    if [ ! -f "$BACKEND_DIR/.env" ]; then
        echo "Backend .env file does not exist. Creating a new one..."
        cat > "$BACKEND_DIR/.env" <<EOF
USERNAME=CISE-username
PASSWORD=CISE-password
JWT_SECRET=$(openssl rand -hex 32)
EOF
        echo "Backend .env file created with username, password, and JWT_SECRET."
        add_to_summary "Backend .env file was created with username, password, and JWT_SECRET."
    else
        echo "Backend .env file already exists. Skipping creation."
        add_to_summary "Backend .env file was confirmed to already exist."
    fi

    # Create frontend .env file
    if [ ! -f "$FRONTEND_DIR/.env" ]; then
        echo "Frontend .env file does not exist. Creating a new one..."
        cat > "$FRONTEND_DIR/.env" <<EOF
REACT_APP_API_URL=http://localhost:8080
REACT_APP_JWT_SECRET=$(openssl rand -hex 32)
EOF
        echo "Frontend .env file created with REACT_APP_API_URL and JWT_SECRET."
        add_to_summary "Frontend .env file was created with REACT_APP_API_URL and JWT_SECRET."
    else
        echo "Frontend .env file already exists. Skipping creation."
        add_to_summary "Frontend .env file was confirmed to already exist."
    fi
}

# Function to secure the .env files for both backend and frontend
secure_env_files() {
    # Secure backend .env file
    if [ -f "$BACKEND_DIR/.env" ]; then
        if [[ "$OS" == "mac" || "$OS" == "linux" ]]; then
            chmod 600 "$BACKEND_DIR/.env"
        elif [[ "$OS" == "windows" ]]; then
            icacls "$BACKEND_DIR/.env" /inheritance:r /grant "%USERNAME%:RW"
        fi
        echo "Backend .env file secured."
        add_to_summary "Backend .env file was secured."
    else
        echo "Backend .env file not found. Skipping security update."
        add_to_summary "Backend .env file not found. Skipping security update."
    fi

    # Secure frontend .env file
    if [ -f "$FRONTEND_DIR/.env" ]; then
        if [[ "$OS" == "mac" || "$OS" == "linux" ]]; then
            chmod 600 "$FRONTEND_DIR/.env"
        elif [[ "$OS" == "windows" ]]; then
            icacls "$FRONTEND_DIR/.env" /inheritance:r /grant "%USERNAME%:RW"
        fi
        echo "Frontend .env file secured."
        add_to_summary "Frontend .env file was secured."
    else
        echo "Frontend .env file not found. Skipping security update."
        add_to_summary "Frontend .env file not found. Skipping security update."
    fi
}

# Function to check and set permissions for scripts
set_script_permissions() {
    SCRIPTS=("start_backend.sh" "start_frontend.sh" "run_app.sh" "run_appH2.sh" "nuke.sh")
    for script in "${SCRIPTS[@]}"; do
        if [ -f "scripts/$script" ]; then
            chmod u+rwx "scripts/$script"
            echo "Permissions updated for $script"
            add_to_summary "Permissions updated for $script"
        else
            echo "Could not find $script. Your repository may be corrupted or may need to be re-pulled."
            add_to_summary "Could not find $script. Your repository may be corrupted or may need to be re-pulled."
        fi
    done
}

# Detect the operating system
detect_os
add_to_summary "Operating System detected: $OS"

# macOS setup using Homebrew if needed
if [[ "$OS" == "mac" || "$OS" == "linux" ]]; then

    add_to_summary "Key Software checks were made"
    # Check if Node.js (with npm and npx) is installed
    if ! command -v node &> /dev/null; then
        ask_to_install "Node.js (which includes npm and npx)" "brew install node" "node"
        add_to_summary "Node.js was installed via Homebrew."
    else
        echo "Node.js (with npm and npx) is already installed."
        add_to_summary "Node.js (with npm and npx) was already installed."
    fi

    # Check if Java (JRE or JDK) is installed
    if ! command -v java &> /dev/null; then
        ask_to_install "Java (JRE or JDK)" "brew install openjdk" "java"
        add_to_summary "Java was installed via Homebrew."
    else
        echo "Java is already installed."
        add_to_summary "Java was already installed."
    fi

    # Check if Maven is installed
    if ! command -v mvn &> /dev/null; then
        ask_to_install "Maven" "brew install maven" "mvn"
        add_to_summary "Maven was installed via Homebrew."
    else
        echo "Maven is already installed."
        add_to_summary "Maven was already installed."
    fi

# Windows setup with manual download instructions
elif [[ "$OS" == "windows" ]]; then
    echo "For Windows, this script will guide you to download and install missing dependencies manually."
    add_to_summary "Manual installation instructions were provided for Windows dependencies."
    # Check for Node.js
    if ! command -v node &> /dev/null; then
        echo "Node.js is not installed. Please download and install Node.js from https://nodejs.org."
        read -p "Press Enter after you have installed Node.js to continue..."
        if command -v node &> /dev/null; then
            echo "Node.js (with npm and npx) was installed successfully."
        else
            echo "Node.js installation was not successful. Please ensure the following:"
            echo "1. Verify the installation by reopening this script after confirming Node.js is installed."
            echo "2. If Node.js is installed but not detected, add Node.js to the PATH manually."
            echo "   - Open System Properties > Advanced > Environment Variables."
            echo "   - In 'System Variables', find the 'Path' variable, select it, and click Edit."
            echo "   - Add the Node.js installation path (usually C:\\Program Files\\nodejs\\) to PATH."
            echo "   - Restart this script or open a new command prompt and try again."
            add_to_summary "Node not installed"
            summary_report 1
        fi
    else
        echo "Node.js (with npm and npx) is already installed."
        add_to_summary "Node.js (with npm and npx) was already installed."
    fi

    # Check for Java
    if ! command -v java &> /dev/null; then
        echo "Java (JRE or JDK) is not installed. Please download and install Java from one of the following sources:"
        echo "1. Oracle Java SE: https://www.oracle.com/java/technologies/javase-downloads.html"
        echo "2. OpenJDK (recommended): https://adoptopenjdk.net/"
        read -p "Press Enter after you have installed Java to continue..."
        if command -v java &> /dev/null; then
            echo "Java was installed successfully."
            add_to_summary "Java was installed successfully."
        else
            echo "Java installation was not successful. Please ensure the following:"
            echo "1. Verify that Java is installed by reopening this script after confirmation."
            echo "2. If installed but not detected, add Java to the PATH manually."
            echo "   - Open System Properties > Advanced > Environment Variables."
            echo "   - In 'System Variables', find the 'Path' variable, select it, and click Edit."
            echo "   - Add the Java installation path (e.g., C:\\Program Files\\Java\\jdk-<version>\\bin) to PATH."
            echo "   - Restart this script or open a new command prompt and try again."
            add_to_summary "Java not installed"
            summary_report 1
        fi
    else
        echo "Java is already installed."
        add_to_summary "Java was already installed."
    fi

    # Check for Maven
    if ! command -v mvn &> /dev/null; then
        echo "Maven is not installed. Please download and install Maven from https://maven.apache.org/download.cgi."
        echo "After downloading, follow the instructions to add Maven to your PATH."
        read -p "Press Enter after you have installed Maven to continue..."
        if command -v mvn &> /dev/null; then
            echo "Maven was installed successfully."
            add_to_summary "Maven was installed successfully."
        else
            echo "Maven installation was not successful. Please ensure the following:"
            echo "1. Verify that Maven is installed by reopening this script after confirmation."
            echo "2. If installed but not detected, add Maven to the PATH manually."
            echo "   - Open System Properties > Advanced > Environment Variables."
            echo "   - In 'System Variables', find the 'Path' variable, select it, and click Edit."
            echo "   - Add the Maven 'bin' path (e.g., C:\\apache-maven-<version>\\bin) to PATH."
            echo "   - Restart this script or open a new command prompt and try again."
            add_to_summary "Maven not installed"
            summary_report 1
        fi
    else
        echo "Maven is already installed."
        add_to_summary "Maven was already installed."
    fi
fi

# Use the function to find the project root
PROJECT_ROOT=$(find_project_root)
add_to_summary "Project root directory identified as: $PROJECT_ROOT"

# Change to the project root directory
cd "$PROJECT_ROOT" || { add_to_summary "Failed to navigate to project root: $PROJECT_ROOT"; summary_report 1; }

# Define key paths relative to the project root
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"
LOGS_DIR="$PROJECT_ROOT/Logs"
SCRIPTS_DIR="$PROJECT_ROOT/scripts"

# Create the logs folder if it doesn't exist
if [ ! -d "$LOGS_DIR" ]; then
    mkdir "$LOGS_DIR"
    echo "Created logs directory: $LOGS_DIR"
        add_to_summary "Logs directory created."
    else
        add_to_summary "Logs directory already exists."
fi

# Check for backend folder
if [ -d "$BACKEND_DIR" ]; then
    echo "Backend folder exists. Navigating to it for setup..."
    cd "$BACKEND_DIR" || { add_to_summary "Failed to navigate to backend directory: $BACKEND_DIR"; summary_report 1; }
    add_to_summary "Navigated to the backend directory."
else
    echo "Backend folder not found at: $BACKEND_DIR"
    add_to_summary "Backend folder not found. Exiting setup."
    summary_report 1
fi

# Manually resolve dependencies in the backend using Maven
echo "Resolving Maven dependencies in the backend folder..."
mvn dependency:resolve -X | tee "$LOGS_DIR/maven_resolve_debug.log"
MAVEN_EXIT_CODE=${PIPESTATUS[0]}  # Capture Maven's exit code

if [ $MAVEN_EXIT_CODE -eq 0 ]; then
    add_to_summary "Maven dependencies resolved successfully."
else
    echo "Maven dependency resolution failed. Exit code: $MAVEN_EXIT_CODE"
    echo "======================================================================"
    echo "Log output from Maven (last 20 lines):"
    tail -n 20 "../$LOGS_DIR/maven_resolve_debug.log"
    echo "======================================================================"
    echo "Checking for error keywords:"
    grep -i "error" "../$LOGS_DIR/maven_resolve_debug.log" || echo "No specific error keywords found."
    echo "======================================================================"
    add_to_summary "Failed to resolve Maven dependencies."
    summary_report 1
fi

# Ensure that Maven installs all dependencies and builds the project
echo "Building the backend project for Oracle Database to ensure dependencies are installed..."
mvn clean install -DskipTests 2>&1 | tee "$LOGS_DIR/maven_build.log"
STATUS=$?
if [ $STATUS -eq 0 ]; then
    echo "Maven build succeeded, and dependencies are installed."
    add_to_summary "Maven build succeeded, and dependencies were installed."
    echo "Logs for resolving dependencies and building can be found in maven_resolve.log and maven_build.log respectively."
    add_to_summary "Logs for resolving dependencies and building can be found in maven_resolve.log and maven_build.log respectively."
else
    echo "Maven build failed. Please check for errors in the backend project."
    echo "Check the log file at ../maven_build.log for more details."
    add_to_summary "Maven build failed. Check the logs for more details."
    summary_report 1
fi

# Navigate back to the project root
cd "$PROJECT_ROOT" || { add_to_summary "Failed to navigate back to project root: $PROJECT_ROOT"; summary_report 1; }
add_to_summary "Returned to the root directory after backend setup."

# Check for frontend folder
if [ -d "$FRONTEND_DIR" ]; then
    echo "Frontend folder exists. Navigating to it for setup..."
    cd "$FRONTEND_DIR" || { add_to_summary "Failed to navigate to frontend directory: $FRONTEND_DIR"; summary_report 1; }
    add_to_summary "Navigated to the frontend directory."
else
    echo "Frontend folder not found at: $FRONTEND_DIR"
    add_to_summary "Frontend folder not found. Exiting setup."
    summary_report 1
fi

# Run npm install
echo "Installing dependencies in the frontend folder..."
npm install
if [ $? -eq 0 ]; then
    add_to_summary "Frontend dependencies installed successfully."
else
    add_to_summary "Failed to install frontend dependencies."
    summary_report 1
fi

# Navigate back to the root directory
cd "$PROJECT_ROOT"
add_to_summary "Returned to the root directory after frontend setup."

# Create the .env file if it does not exist
create_env_files

# Secure the .env file
secure_env_files

# Set permissions for scripts (Mac only)
if [[ "$OS" == "mac" || "$OS" == "linux" ]]; then
  set_script_permissions
fi

# Display the summary report
add_to_summary "Setup Complete."
summary_report