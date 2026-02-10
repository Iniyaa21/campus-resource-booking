BEGIN;

-- 1) Add approval/audit columns
ALTER TABLE bookings
  ADD COLUMN approved_by UUID REFERENCES users(user_id),
  ADD COLUMN approved_at TIMESTAMP,
  ADD COLUMN rejection_reason TEXT;

-- 2) Drop existing unnamed/old check constraint (safe-guard)
ALTER TABLE bookings
  DROP CONSTRAINT IF EXISTS bookings_booking_status_check;

-- 3) Add new named CHECK constraint for workflow statuses
ALTER TABLE bookings
  ADD CONSTRAINT bookings_booking_status_check
    CHECK (booking_status IN ('PENDING','APPROVED','REJECTED','CANCELLED'));

-- 4) Set default for new bookings
ALTER TABLE bookings
  ALTER COLUMN booking_status SET DEFAULT 'PENDING';

-- 5) Recreate overlap constraint so only APPROVED bookings block
ALTER TABLE bookings DROP CONSTRAINT IF EXISTS no_overlap;
ALTER TABLE bookings ADD CONSTRAINT no_overlap
  EXCLUDE USING gist (
    resource_id WITH =,
    tstzrange(start_time, end_time) WITH &&
  )
  WHERE (booking_status = 'APPROVED');

-- 6) Migrate existing data: treat previous CONFIRMED as APPROVED
UPDATE bookings
SET booking_status = 'APPROVED',
    approved_at = COALESCE(approved_at, created_at),
    approved_by = NULL
WHERE booking_status = 'CONFIRMED';

COMMIT;