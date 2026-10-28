# ServiceDesk — Software Architecture

## 1. Overview

ServiceDesk is a full-stack IT Service Management (ITSM) application designed to manage IT support tickets, users, teams, and support workflows.

The application follows a modular monolithic architecture, with a separate frontend and backend.

The main architectural goals are:

- Separation of concerns.
- Maintainability and testability.
- Clear API contracts.
- Secure access to application resources.
- Reliable data persistence.
- Reproducible development and deployment environments.

This document describes the intended architecture. Details will be updated as implementation decisions are finalized.

## 2. Architectural Style

ServiceDesk uses a modular monolithic architecture.

The application consists of:

- A React frontend responsible for user interaction.
- A Spring Boot backend responsible for business logic and data access.
- A PostgreSQL database responsible for persistent storage.

The frontend and backend are developed independently but belong to the same Git repository.

The backend is organized into logical modules and layers rather than being split into independent microservices.

### Rationale

A modular monolith keeps deployment and operational complexity low while providing clear boundaries between responsibilities.

Microservices are not part of the initial architecture.

## 3. High-Level Architecture

```text
                  User
                    |
                    v
        +------------------------+
        | React + TypeScript     |
        | Web Frontend           |
        +-----------+------------+
                    |
                    | HTTP / REST
                    v
        +------------------------+
        | Spring Boot Backend    |
        |                        |
        | Controllers            |
        | Services               |
        | Repositories           |
        | Security               |
        +-----------+------------+
                    |
                    | JPA / Hibernate
                    v
        +------------------------+
        | PostgreSQL             |
        | Persistent Data         |
        +------------------------+
```

The frontend communicates with the backend through a documented REST API.

The backend validates requests, enforces business rules, applies authorization policies, and manages database transactions.

The database stores application data persistently.

## 4. Repository Structure

The repository is organized as follows:

```text
ServiceDesk/
├── backend/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   └── resources/
│   │   └── test/
│   └── pom.xml
├── frontend/
│   ├── src/
│   ├── public/
│   └── package.json
├── docs/
│   └── architecture.md
├── docker-compose.yml
├── .gitignore
├── LICENSE
└── README.md
```

The structure may evolve as the application grows.

## 5. Backend Architecture

The backend is implemented in Java using Spring Boot.

It follows a layered architecture with the following responsibilities.

### 5.1 Controllers

Controllers expose HTTP endpoints and translate incoming requests into application operations.

Responsibilities:

- Define REST endpoints.
- Validate request structures.
- Delegate business operations to services.
- Return appropriate HTTP status codes and response DTOs.

Controllers should not contain complex business logic or directly manage persistence.

### 5.2 Services

Services implement business rules and coordinate application operations.

Responsibilities:

- Enforce ticket lifecycle rules.
- Coordinate operations across repositories.
- Define transaction boundaries where required.
- Apply business validations and authorization-related rules.

Business logic should remain independent of HTTP-specific concerns wherever practical.

### 5.3 Repositories

Repositories provide access to persistent data using Spring Data JPA and Hibernate.

Responsibilities:

- Retrieve and persist entities.
- Execute queries and filters.
- Support pagination and sorting.
- Keep database access separate from business logic.

### 5.4 Domain Model

The domain model represents the main concepts of the application.

Initial domain concepts include:

- Ticket
- User
- Team
- TicketComment
- TicketHistory

The final entities, attributes, relationships, and constraints will be documented when the data model is implemented.

### 5.5 Data Transfer Objects

DTOs define the data exchanged through the API.

They prevent internal persistence entities from automatically becoming public API contracts.

Input DTOs and response DTOs should be designed according to the needs of each operation.

### 5.6 Security

Spring Security is responsible for authentication and request-level authorization.

The implementation will define:

- Authentication mechanisms.
- Application roles and permissions.
- Access rules for protected endpoints.
- Password handling and credential storage.
- Security-related tests.

The final authentication flow and token or session strategy must be documented after implementation.

## 6. Frontend Architecture

The frontend is implemented using React and TypeScript.

It is responsible for presenting information, collecting user input, and interacting with the backend API.

The frontend should be organized around reusable components and clearly defined responsibilities.

Suggested areas include:

- `components/` — reusable interface components.
- `pages/` — application pages.
- `services/` — API communication.
- `types/` — shared frontend type definitions.
- `hooks/` — reusable React hooks.
- `layouts/` — common page layouts.

The actual folder structure will follow the needs of the application.

The frontend must handle loading states, validation feedback, API errors, and access restrictions in the user interface.

Backend authorization remains the authoritative security boundary.

## 7. Data Architecture

PostgreSQL is the planned relational database.

Spring Data JPA and Hibernate provide object-relational mapping.

Flyway is planned for version-controlled database migrations.

The data model must support:

- Ticket ownership and assignment.
- Ticket priority and status.
- User and team relationships.
- Comments and relevant change history.
- Filtering, sorting, and pagination.

Database constraints and indexes will be introduced according to the data model and observed query requirements.

Transactions will be applied where operations require consistent changes across multiple records.

## 8. API Design

The backend exposes a REST API over HTTP.

API design principles include:

- Resource-oriented URLs.
- Appropriate HTTP methods and status codes.
- Request validation.
- Consistent error responses.
- Pagination and filtering for collection endpoints.
- Explicit request and response DTOs.
- API documentation using OpenAPI.

The API contract will evolve with the implemented features.

## 9. Testing Strategy

Testing is an integral part of development.

### Backend

- Unit tests for business rules.
- Service tests using JUnit and Mockito.
- Integration tests for persistence and API behavior.
- Security tests for protected endpoints.
- Testcontainers where real infrastructure dependencies are required.

### Frontend

- Tests for important component behavior.
- Tests for form validation and error states.
- Integration tests for critical user workflows where appropriate.

Tests should focus on observable behavior and meaningful failure scenarios rather than implementation details alone.

## 10. Deployment and Operations

Docker and Docker Compose are planned for reproducible local environments.

The deployment architecture is expected to include:

- Frontend application.
- Spring Boot backend.
- PostgreSQL database.

GitHub Actions will be used to automate build and test workflows.

Environment-specific configuration must be externalized. Secrets must not be committed to the repository.

Deployment documentation will describe the selected hosting environment, database provisioning, HTTPS configuration, health checks, and operational requirements once these decisions are implemented.

## 11. Security Principles

The architecture follows these principles:

- Apply least-privilege access.
- Validate untrusted input on the backend.
- Enforce authorization on protected operations.
- Store credentials securely.
- Avoid exposing secrets in source code or logs.
- Use secure transport for deployed environments.
- Test access-control rules.
- Keep dependencies updated and review security advisories.

## 12. Architectural Decisions

The following decisions establish the initial direction.

| Decision | Rationale |
|---|---|
| Modular monolith | Reduce operational complexity and keep responsibilities organized. |
| Separate frontend and backend | Allow independent development and clear API boundaries. |
| Java and Spring Boot | Provide the backend application framework. |
| React and TypeScript | Support a component-based frontend with static type checking. |
| PostgreSQL | Provide relational persistence and SQL support. |
| REST API | Establish a clear communication contract between frontend and backend. |
| Docker Compose | Simplify local environment setup and reproducibility. |
| Automated testing | Reduce regression risk and support maintainable changes. |

These decisions may be revised when requirements or implementation evidence justify a change.

## 13. Future Considerations

Potential future improvements include:

- More detailed audit trails.
- Email or other notification mechanisms.
- Improved observability and metrics.
- Cloud deployment.
- Performance optimization based on measurements.
- Additional integration tests and frontend automation.

These are future considerations, not committed features.

## 14. Document Maintenance

This document must be updated when significant architectural decisions change.

Implementation details should reflect the actual codebase. Planned components must not be described as implemented until they have been verified.

The architecture should remain as simple as possible while meeting the application's functional, security, and quality requirements.