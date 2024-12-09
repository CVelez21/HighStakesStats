# HighStakesStats

HighStakesStats is a comprehensive full-stack web application that delivers dynamic data analytics and visualizations for Major League Baseball. Built with a modern tech stack, it offers an interactive user experience, a secure backend, and seamless integration with Oracle and in-memory databases.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Setup Instructions](#setup-instructions)
   - [Prerequisites](#prerequisites)
   - [Running the Setup Script](#running-the-setup-script)
- [Usage](#usage)
   - [Running the Application](#running-the-application)
   - [Running with H2 Test Database](#running-with-h2-test-database)
   - [Manually Starting Frontend and Backend](#manually-starting-frontend-and-backend)
- [Project Structure](#project-structure)
- [Development Scripts](#development-scripts)
- [License](#license)

---

## Features

- **Interactive Visualizations**: Charts and graphs to analyze player and team performance.
- **Database Flexibility**: Supports Oracle SQL for production and H2 for testing.
- **User Authentication**: JWT-based secure login.
- **Responsive Design**: Works across desktop, tablet, and mobile.
- **Dynamic Filtering**: View statistics filtered by various metrics in real time.
- **Robust API**: RESTful API for seamless frontend-backend communication.

---

## Tech Stack

- **Frontend**: React, Recharts (for data visualization).
- **Backend**: Spring Boot, Spring Security, JWT Authentication.
- **Database**: Oracle SQL (production) and H2 (testing).
- **Build Tools**: Maven (backend), npm (frontend).
- **Development Environment**: IntelliJ IDEA with Maven module setup.

---

## Setup Instructions

### Prerequisites

Ensure the following tools are installed and accessible via the terminal:

- **Node.js**: Download and install from [Node.js](https://nodejs.org/).
- **Java 17+**: Install a JDK, e.g., OpenJDK or Oracle JDK.
- **Maven**: Install from [Maven's official site](https://maven.apache.org/).
- **Oracle Database**: Ensure access to an Oracle database instance.

### Running the Setup Script

Once prerequisites are installed, clone the repository and run the `setup.sh` script to set up the project. The script:
- Installs backend and frontend dependencies.
- Configures environment variables for development.
- Resolves Maven dependencies.
- Ensures required permissions for project scripts.

```bash
./setup.sh
```

# Usage

The **HighStakesStats** application is a powerful tool for visualizing and analyzing sports statistics. It offers the following features:

1. **Interactive Dashboards**: Explore statistics with dynamic charts and filtering options.
2. **Data Management**: Update, delete, and manage team or player stats.
3. **Test and Production Modes**: Easily switch between:
  - **Oracle Database** for production use.
  - **H2 Database** for testing purposes.

## Running the Application

To start the application with the Oracle database configuration, use:

```bash
./run_app.sh
```
Logs will be available in the `Logs/` directory:
- `backend.log`: Spring Boot backend logs.
- `frontend.log`: React frontend logs.

## Running with H2 Test Database

For testing purposes, run the application using the H2 in-memory database:
```bash
./run_appH2.sh
```

Logs for this configuration will be saved as:
- `backendH2.log`
- `frontendH2.log`

## Manually Starting Frontend and Backend

If needed, you can start each component manually:

### Start Backend

Navigate to the backend directory and run:
```bash
cd backend
mvn spring-boot:run
```

### Start Frontend

Navigate to the frontend directory and run:
```bash
cd frontend
npm start
```

## Project Structure

The repository is organized as follows:

```plaintext
HighStakesStats/
├── backend/               # Spring Boot backend
│   ├── src/               # Source code
│   │   ├── main/          # Main application
│   │   │   ├── java/      # Java source files
│   │   │   ├── resources/ # Properties and configurations
│   │   └── test/          # Test files
│   ├── pom.xml            # Maven configuration
├── frontend/              # React frontend
│   ├── src/               # React source code
│   ├── public/            # Static assets
│   ├── package.json       # npm dependencies
├── scripts/               # Utility scripts
│   ├── setup.sh           # Project setup script
│   ├── run_app.sh         # Start app with Oracle database
│   ├── run_appH2.sh       # Start app with H2 test database
│   ├── nuke.sh            # Cleanup/reset script
├── Logs/                  # Log files
├── .idea/                 # IntelliJ IDEA configuration (optional)
├── README.md              # Project documentation
```


### Script Overview

| Script       | Purpose                                       |
|--------------|-----------------------------------------------|
| `setup.sh`   | Sets up dependencies and environment variables. |
| `run_app.sh` | Starts the application with Oracle database.  |
| `run_appH2.sh` | Starts the application with H2 test database. |
| `nuke.sh`    | Cleans up all generated files and dependencies. |