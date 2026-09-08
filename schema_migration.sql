-- ============================================================
-- TOOTHY CLINIC APP — DATABASE SCHEMA MIGRATION
-- ============================================================
-- Generated: 2026-06-22
-- Run this ONCE in Supabase SQL Editor (Dashboard → SQL → New Query)
-- 
-- Changes:
--   1. Procedure — Clean duplicates + unique constraint
--   2. Patient — Add medical fields
--   3. History — Add procedure_id
--   4. Payments — Add appointment_id + procedure_id
--   5. Leave_Request — New table
--   6. Notification — New table (in-app only)
-- ============================================================

BEGIN;

-- ==========================================================
-- 1. PROCEDURE — Clean duplicates + unique constraint
-- ==========================================================

-- Remove 3 unreferenced duplicate procedures
DELETE FROM "Procedure" WHERE procedure_id IN (
  'f00385b5-ffed-4e4e-af31-e91be2e44ca5',
  'c4698e7e-fe76-431c-8368-113753d7c383',
  'de3d6ebb-f69c-491e-8c6a-8afb14f26095'
);

-- Prevent future duplicates
ALTER TABLE "Procedure"
  ADD CONSTRAINT unique_procedure_name UNIQUE (procedure_name);


-- ==========================================================
-- 2. PATIENT — Add medical fields
-- ==========================================================

ALTER TABLE "Patient"
  ADD COLUMN IF NOT EXISTS allergies TEXT,
  ADD COLUMN IF NOT EXISTS medical_conditions TEXT,
  ADD COLUMN IF NOT EXISTS blood_type TEXT,
  ADD COLUMN IF NOT EXISTS emergency_contact_name TEXT,
  ADD COLUMN IF NOT EXISTS emergency_contact_phone TEXT;


-- ==========================================================
-- 3. HISTORY — Add procedure_id for direct linkage
-- ==========================================================

ALTER TABLE "History"
  ADD COLUMN IF NOT EXISTS procedure_id UUID;


-- ==========================================================
-- 4. PAYMENTS — Add appointment_id + procedure_id
--    (keeping existing paid_for column untouched)
-- ==========================================================

ALTER TABLE "Payments"
  ADD COLUMN IF NOT EXISTS appointment_id UUID,
  ADD COLUMN IF NOT EXISTS procedure_id UUID;


-- ==========================================================
-- 5. LEAVE_REQUEST — New table for dentist leave management
-- ==========================================================

CREATE TABLE IF NOT EXISTS "Leave_Request" (
  request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dentist_id UUID NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  reason TEXT,
  status TEXT NOT NULL DEFAULT 'Pending',
  reviewed_by UUID,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Status values: 'Pending', 'Approved', 'Rejected'


-- ==========================================================
-- 6. NOTIFICATION — New table for in-app notifications
-- ==========================================================

CREATE TABLE IF NOT EXISTS "Notification" (
  notification_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'general',
  reference_id UUID,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- type values:
--   'booking_confirmed'      — patient booked an appointment
--   'appointment_reminder'   — upcoming appointment reminder
--   'status_change'          — appointment confirmed/cancelled/rescheduled
--   'leave_approved'         — dentist leave request approved
--   'leave_rejected'         — dentist leave request rejected
--   'general'                — general admin announcements


COMMIT;

-- ==========================================================
-- VERIFICATION — Run after migration to confirm
-- ==========================================================
-- Uncomment and run to verify:
--
-- SELECT 'Procedure unique constraint' AS check_name,
--        COUNT(*) AS count
-- FROM information_schema.table_constraints
-- WHERE constraint_name = 'unique_procedure_name';
--
-- SELECT 'Patient new columns' AS check_name,
--        COUNT(*) AS count
-- FROM information_schema.columns
-- WHERE table_name = 'Patient'
--   AND column_name IN ('allergies','medical_conditions','blood_type','emergency_contact_name','emergency_contact_phone');
--
-- SELECT 'History procedure_id' AS check_name,
--        COUNT(*) AS count
-- FROM information_schema.columns
-- WHERE table_name = 'History' AND column_name = 'procedure_id';
--
-- SELECT 'Payments new columns' AS check_name,
--        COUNT(*) AS count
-- FROM information_schema.columns
-- WHERE table_name = 'Payments'
--   AND column_name IN ('appointment_id','procedure_id');
--
-- SELECT 'Leave_Request table' AS check_name,
--        COUNT(*) AS count
-- FROM information_schema.tables
-- WHERE table_name = 'Leave_Request';
--
-- SELECT 'Notification table' AS check_name,
--        COUNT(*) AS count
-- FROM information_schema.tables
-- WHERE table_name = 'Notification';
