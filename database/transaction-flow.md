Booking Creation Transaction Flow

1. Begin transaction
2. Check overlapping bookings using:
   SELECT ... FOR UPDATE
3. If overlap exists → rollback
4. Else insert booking
5. Commit transaction

Conflict rule:
existing.start_time < new_end_time
AND existing.end_time > new_start_time

This guarantees strong consistency and prevents double booking
under concurrent requests.
