Booking Conflict Handling

Two bookings are said to conflict if they overlap in time
for the same resource.

Conflict condition:
existing.start_time < new.end_time
AND
existing.end_time > new.start_time

This check must be executed inside a database transaction
to prevent race conditions when multiple users attempt to
book the same resource simultaneously.

Only bookings with status 'pending' or 'approved' are
considered during conflict detection.
