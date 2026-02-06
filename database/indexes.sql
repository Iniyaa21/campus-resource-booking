CREATE INDEX idx_bookings_resource_time
ON bookings(resource_id, start_time, end_time);

CREATE INDEX idx_bookings_status
ON bookings(status);
