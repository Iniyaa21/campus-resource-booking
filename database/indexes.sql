CREATE INDEX idx_booking_resource_time
ON bookings(resource_id, start_time, end_time);

CREATE INDEX idx_booking_user
ON bookings(user_id);

CREATE INDEX idx_booking_status
ON bookings(booking_status);
