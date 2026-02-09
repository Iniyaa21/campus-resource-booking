# API Specification

All APIs are JSON-based and follow REST principles.
The backend is the authority for validation and correctness.

---

## User APIs

### Create User
`POST /users`

**Request**
```json
{
  "name": "Jahoda",
  "email": "jahoda@college.edu",
  "role": "student"
}
````

**Response**

```json
{
  "user_id": "uuid",
  "role": "student"
}
```

---

## Resource APIs

### Create Resource (Admin)

`POST /resources`

**Request**

```json
{
  "resource_name": "Lab 5",
  "resource_type": "LAB",
  "availability_status": "ACTIVE"
}
```

**Response**

```json
{
  "resource_id": "uuid"
}
```

---

### List Resources

`GET /resources`

**Response**

```json
[
  {
    "resource_id": "uuid",
    "resource_name": "Lab 5",
    "resource_type": "LAB",
    "availability_status": "ACTIVE"
  }
]
```

---

### Get Resource Availability

`GET /resources/:id/availability`

**Query Params**

```
date=YYYY-MM-DD
```

**Response**

```json
{
  "resource_id": "uuid",
  "date": "2026-02-10",
  "available_slots": [
    {
      "start_time": "09:00",
      "end_time": "10:00"
    }
  ]
}
```

---

## Booking APIs

### Create Booking

`POST /bookings`

**Request**

```json
{
  "user_id": "uuid",
  "resource_id": "uuid",
  "start_time": "2026-02-10T09:00:00",
  "end_time": "2026-02-10T10:00:00"
}
```

**Success Response**

```json
{
  "booking_id": "uuid",
  "status": "CONFIRMED"
}
```

**Conflict Response**

```json
{
  "error": "RESOURCE_ALREADY_BOOKED"
}
```

---

### Get Booking

`GET /bookings/:id`

**Response**

```json
{
  "booking_id": "uuid",
  "resource_id": "uuid",
  "start_time": "...",
  "end_time": "...",
  "booking_status": "CONFIRMED"
}
```

---

### Get User Bookings

`GET /users/:id/bookings`

**Response**

```json
[
  {
    "booking_id": "uuid",
    "resource_id": "uuid",
    "start_time": "...",
    "end_time": "...",
    "booking_status": "CONFIRMED"
  }
]
```

---

### Cancel Booking

`DELETE /bookings/:id`

**Response**

```json
{
  "status": "CANCELLED"
}
```

---

## Notification APIs

### Get User Notifications

`GET /notifications`

**Response**

```json
[
  {
    "notification_id": "uuid",
    "message": "Your booking has been confirmed",
    "sent_at": "timestamp",
    "read_status": false
  }
]
```

---

### Mark Notification as Read

`PATCH /notifications/:id/read`

**Response**

```json
{
  "read_status": true
}
```

---

## API Design Principles

* Backend validates all requests
* Booking conflicts are detected server-side
* APIs are idempotent where applicable
* Errors are explicit and predictable
* Frontend never computes availability or conflicts
