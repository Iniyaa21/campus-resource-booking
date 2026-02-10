# Booking Conflict Handling

## Definition

Two bookings are considered to be in conflict if they overlap in time
for the **same resource**.

A conflict occurs when an existing confirmed booking intersects with
the requested booking time range.

## Conflict condition

A new booking conflicts with an existing booking if:

existing.start_time < new_end_time
AND
existing.end_time > new_start_time

This condition detects any time overlap between two intervals.

## Status rules

Only bookings with status **'CONFIRMED'** are considered during
conflict detection.

Bookings marked as **'CANCELLED'** are ignored because they no longer
reserve the resource.

## Concurrency safety

Conflict detection must be executed **inside a database transaction**
to prevent race conditions when multiple users attempt to book the same
resource at the same time.

The booking creation flow is:

1. Start transaction
2. Check for overlapping confirmed bookings
3. If conflict exists → abort
4. If no conflict → insert booking
5. Commit transaction

This ensures **strong consistency** and guarantees that a resource
cannot be double-booked.
