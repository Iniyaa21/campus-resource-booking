# Backend Architecture

## Backend Responsibility

The backend is responsible for enforcing all system rules and ensuring
data consistency. It acts as the single authority for booking correctness.

The backend:

- Enforces business rules
- Resolves booking conflicts
- Coordinates database operations
- Exposes stable APIs to the frontend

The backend is **stateless**. All state is stored in the database.

---

## Architecture Style

The backend follows a **layered monolithic architecture**.

API Layer (Routes) -> Controller Layer -> Service Layer -> Repository Layer -> PostgreSQL


Microservices are intentionally avoided to keep the system simple and
maintain strong transactional guarantees.

---

## API Layer (Routes)

### Responsibility
- Defines HTTP endpoints
- Performs request validation
- Enforces role-based access control
- Delegates execution to controllers

### Characteristics
- No business logic
- No database access
- Thin and declarative

### Example Route Groups
- `/users`
- `/resources`
- `/bookings`
- `/notifications`

---

## Controller Layer

### Responsibility
- Orchestrates request flow
- Translates HTTP requests into service calls
- Converts service responses into HTTP responses

### Characteristics
Controllers:
- Do **not** contain SQL queries
- Do **not** manage transactions
- Do **not** implement business rules

They only coordinate execution.

---

## Service Layer (Core Logic)

The service layer contains all **business rules** and **system design decisions**.

---

### Booking Service

#### Responsibility
- Booking lifecycle management
- Conflict detection
- Transactional safety

#### Booking Creation Flow
1. Start a database transaction
2. Check for overlapping bookings for the given resource and time range
3. If a conflict exists, abort the transaction
4. Insert the booking record
5. Generate a notification
6. Commit the transaction

#### Design Guarantees
- No double booking
- Atomic booking creation
- Strong consistency
- Idempotent behavior (same request does not create duplicates)

---

### Resource Service

#### Responsibility
- Resource listing and filtering
- Availability computation
- Read optimization

#### Availability Design
- Availability is **derived**, not stored
- Computed from existing bookings
- Can be cached for read performance (design-level only)

---

### Notification Service

#### Responsibility
- Create notifications for system events
- Fetch notifications for users
- Update read status

#### Design Principle
Notifications are **side effects**, not primary actions.
They are generated as part of booking-related workflows.

---

## Repository Layer

### Responsibility
- Encapsulates all SQL queries
- Provides database operations as functions

### Benefits
- Clear separation between logic and persistence
- Easier testing and debugging
- Ability to change database implementation without affecting services

---

## Backend Non-Functional Properties

- Stateless services (supports horizontal scaling)
- Consistency-first system design
- Write correctness prioritized over availability
- Caching applied only to read operations
- Database is the single source of truth

---

## Error Handling Strategy

- Validation errors → 4xx responses
- Booking conflicts → explicit conflict responses
- Unexpected failures → generic 5xx responses
- No silent failures

---

## Scalability Notes (Design-Level)

- Stateless backend allows load balancing
- Booking writes always hit the database
- Availability reads can be cached
- Strong consistency maintained for critical operations