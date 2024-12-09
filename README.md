# HighStakesStats

HighStakesStats is a comprehensive full-stack web application that delivers dynamic data analytics and visualizations for competitive sports statistics. Built with a modern tech stack, it offers an interactive user experience, a secure backend, and seamless integration with Oracle and in-memory databases.

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