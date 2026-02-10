import db from "../db.js";

/**
 * Create a booking within a transaction and check for conflicts.
 * This implementation uses the booking_status values present in
 * the database schema. The schema allows 'CONFIRMED' or 'CANCELLED'.
 * Per schema, we only consider 'CONFIRMED' bookings as conflicting.
 *
 * Returns { conflict: true } when a conflicting booking exists.
 * Returns { conflict: false, booking } on success.
 */
export async function createBooking({
  resource_id,
  user_id,
  start_time,
  end_time,
}) {
  const client = await db.connect();
  try {
    await client.query("BEGIN");

    const conflictQuery = `
      SELECT booking_id FROM bookings
      WHERE resource_id = $1
        AND start_time < $3
        AND end_time > $2
        AND booking_status = 'CONFIRMED'
      FOR UPDATE
    `;

    const conflictRes = await client.query(conflictQuery, [
      resource_id,
      start_time,
      end_time,
    ]);
    if (conflictRes.rowCount > 0) {
      await client.query("ROLLBACK");
      return { conflict: true };
    }

    const insertRes = await client.query(
      `INSERT INTO bookings (resource_id, user_id, start_time, end_time, booking_status)
       VALUES ($1, $2, $3, $4, 'CONFIRMED')
       RETURNING booking_id, resource_id, user_id, start_time, end_time, booking_status, created_at`,
      [resource_id, user_id, start_time, end_time],
    );

    await client.query("COMMIT");
    return { conflict: false, booking: insertRes.rows[0] };
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    throw err;
  } finally {
    client.release();
  }
}
