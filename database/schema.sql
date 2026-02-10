CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- USERS
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('student','admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RESOURCES
CREATE TABLE resources (
    resource_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    resource_type TEXT,
    capacity INT,
    availability_status TEXT CHECK (
        availability_status IN ('AVAILABLE','UNAVAILABLE','MAINTENANCE')
    ) DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BOOKINGS
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    resource_id UUID REFERENCES resources(resource_id) ON DELETE RESTRICT,
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    booking_status TEXT CHECK (
        booking_status IN ('PENDING','APPROVED','REJECTED','CANCELLED')
    ) DEFAULT 'PENDING',
    approved_by UUID REFERENCES users(user_id),
    approved_at TIMESTAMP,
    rejection_reason TEXT,
);

-- Prevent overlap
ALTER TABLE bookings ADD CONSTRAINT no_overlap
EXCLUDE USING gist (
    resource_id WITH =,
    tstzrange(start_time, end_time) WITH &&
)
WHERE (booking_status = 'APPROVED');

-- NOTIFICATIONS
CREATE TABLE notifications (
    notification_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_status BOOLEAN DEFAULT FALSE
);

-- INDEXES
CREATE INDEX idx_bookings_resource_time
ON bookings (resource_id, start_time, end_time);

CREATE INDEX idx_bookings_user
ON bookings (user_id);

CREATE INDEX idx_bookings_status
ON bookings (booking_status);
