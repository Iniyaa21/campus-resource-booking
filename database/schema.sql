-- USERS
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT CHECK (role IN ('student','admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RESOURCES
CREATE TABLE resources (
    resource_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    resource_type TEXT,
    capacity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BOOKINGS (CRITICAL TABLE)
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    resource_id INT REFERENCES resources(resource_id),
    user_id INT REFERENCES users(user_id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    booking_status TEXT CHECK (
        booking_status IN ('CONFIRMED','CANCELLED')
    ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (start_time < end_time)
);

-- NOTIFICATIONS
CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read BOOLEAN DEFAULT FALSE
);
