# ServiceDesk — IT Service Management Platform

A full-stack IT Service Management (ITSM) application for managing support tickets, tracking incidents, and organizing IT support operations.

**ServiceDesk** is a portfolio project focused on building a maintainable, secure, and testable web application using Java, Spring Boot, React, and TypeScript.

The project is being developed incrementally, with an emphasis on REST API design, relational data modeling, automated testing, application security, and containerized deployment.

## Project Goals

- Build a RESTful backend using Java and Spring Boot.
- Develop a responsive frontend using React and TypeScript.
- Design and manage relational data using PostgreSQL.
- Implement authentication and role-based authorization.
- Apply automated testing and software engineering best practices.
- Automate the build and testing process with CI/CD.
- Package and run the application using Docker.

## Planned Features

- **Ticket Management:** Create, view, update, assign, and track support tickets.
- **Priorities and Statuses:** Organize tickets by priority, status, and other relevant criteria.
- **User and Team Management:** Organize users and IT support teams.
- **Search and Filtering:** Find tickets using filters, sorting, and pagination.
- **Authentication and Authorization:** Restrict access to protected resources according to user permissions.
- **Ticket History:** Track relevant changes made to tickets.
- **Dashboard:** Display ticket statistics and operational indicators.
- **API Documentation:** Document endpoints, request formats, and responses.
- **Automated Testing:** Validate business rules, persistence, and API behavior.

Features will be marked as implemented as they become available.

## Technology Stack

### Backend
- Java
- Spring Boot
- Spring Web
- Spring Security
- Spring Data JPA and Hibernate
- Maven

### Frontend
- React
- TypeScript
- JavaScript
- HTML5 and CSS3
- Vite

### Database
- PostgreSQL
- Flyway for database migrations

### Testing and Quality
- JUnit 5
- Mockito
- Testcontainers
- OpenAPI

### DevOps and Tooling
- Git and GitHub
- Docker and Docker Compose
- GitHub Actions
- Linux

The final versions and dependencies will be documented as the implementation evolves.

## Architecture

ServiceDesk is designed as a modular monolithic application with a separate frontend and backend.

```text
┌───────────────────────────┐
│   React + TypeScript      │
│   Web Frontend            │
└─────────────┬─────────────┘
              │ HTTP / REST
              ▼
┌───────────────────────────┐
│   Spring Boot             │
│                           │
│   Controllers             │
│       ↓                   │
│   Services                │
│       ↓                   │
│   Repositories            │
└─────────────┬─────────────┘
              │ JPA / Hibernate
              ▼
┌───────────────────────────┐
│   PostgreSQL              │
└───────────────────────────┘
```

The architecture separates presentation, business logic, persistence, and data storage to improve maintainability and testability.

## Project Structure

The repository is expected to follow a structure similar to:

```text
servicedesk/
├── backend/
│   ├── src/
│   │   ├── main/
│   │   └── test/
│   └── pom.xml
├── frontend/
│   ├── src/
│   ├── package.json
│   └── vite.config.ts
├── docs/
├── docker-compose.yml
└── README.md
```

The actual structure may differ as the implementation evolves.

## Getting Started

### Prerequisites

Install the tools required by the current implementation:

- A compatible JDK
- Maven
- Node.js and npm
- PostgreSQL, or Docker with Docker Compose
- Git

### Installation

Clone the repository:

```bash
git clone <repository-url>
cd servicedesk
```

Configure the backend environment variables and database connection using the configuration documented in the backend directory.

Build and run the backend:

```bash
cd backend
./mvnw clean verify
./mvnw spring-boot:run
```

Install frontend dependencies and start the development server:

```bash
cd frontend
npm install
npm run dev
```

The commands above assume the repository contains the corresponding Maven wrapper and frontend scripts. Follow the actual project configuration if it differs.

## Configuration and Security

Configuration should be provided through environment variables or an appropriate local configuration mechanism.

- Do not commit passwords, API keys, tokens, or production credentials.
- Do not use production credentials in development or test environments.
- Apply authentication and authorization checks on the backend.
- Use HTTPS and secure configuration when deploying the application.

## Testing

Backend verification:

```bash
cd backend
./mvnw clean verify
```

Frontend verification:

```bash
cd frontend
npm run build
```

Additional test commands will be documented as unit, integration, and frontend tests are introduced.

## Development Roadmap

- [ ] Java fundamentals and domain model
- [ ] REST API and core business rules
- [ ] PostgreSQL persistence and database migrations
- [ ] Validation and standardized error handling
- [ ] Authentication and authorization
- [ ] Automated backend tests
- [ ] React and TypeScript frontend
- [ ] Frontend and backend integration
- [ ] Ticket history and dashboard
- [ ] Docker-based execution
- [ ] CI/CD pipeline
- [ ] Deployment and operational documentation

## Engineering Principles

The project prioritizes:

- Separation of concerns and modular design
- Clear and consistent API contracts
- Data validation and appropriate error handling
- Automated testing and regression prevention
- Secure configuration and access control
- Reproducible builds and deployment
- Documentation of technical decisions

## Project Status

**Status:** In development.

ServiceDesk is being built as a practical full-stack software engineering project. The roadmap describes intended capabilities, not a claim that all features are currently implemented.

## License

[![NPM](https://img.shields.io/npm/l/react)](https://github.com/amac81/ServiceDesk/blob/main/LICENSE) 

## Author

Arnaldo Manuel de Almeida Canelas

https://www.linkedin.com/in/arnaldocanelas

Developed as a portfolio project to demonstrate full-stack application development with Java, Spring Boot, React, and TypeScript.
