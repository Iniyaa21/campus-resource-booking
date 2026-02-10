-- USERS
INSERT INTO users (name, email, role)
VALUES
('Alice Johnson','alice@campus.edu','student'),
('Bob Admin','admin@campus.edu','admin'),
('Charlie Student','charlie@campus.edu','student');

-- RESOURCES
INSERT INTO resources (name, resource_type, capacity, availability_status)
VALUES
('Conference Room A','ROOM',10,'AVAILABLE'),
('Conference Room B','ROOM',6,'AVAILABLE'),
('Projector 1','EQUIPMENT',1,'AVAILABLE');

-- BOOKINGS (using subqueries to fetch UUIDs automatically)
INSERT INTO bookings (resource_id, user_id, start_time, end_time)
VALUES (
    (SELECT resource_id FROM resources WHERE name='Conference Room A'),
    (SELECT user_id FROM users WHERE email='alice@campus.edu'),
    NOW() + INTERVAL '1 hour',
    NOW() + INTERVAL '2 hour'
);

INSERT INTO bookings (resource_id, user_id, start_time, end_time)
VALUES (
    (SELECT resource_id FROM resources WHERE name='Conference Room B'),
    (SELECT user_id FROM users WHERE email='charlie@campus.edu'),
    NOW() + INTERVAL '3 hour',
    NOW() + INTERVAL '4 hour'
);

-- NOTIFICATIONS
INSERT INTO notifications (user_id, message)
VALUES (
    (SELECT user_id FROM users WHERE email='alice@campus.edu'),
    'Your booking for Conference Room A is confirmed.'
);

INSERT INTO notifications (user_id, message)
VALUES (
    (SELECT user_id FROM users WHERE email='charlie@campus.edu'),
    'Your booking for Conference Room B is confirmed.'
);
