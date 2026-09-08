-- ============================================================
-- TOOTHY CLINIC APP — TEST DATA SEED SCRIPT
-- ============================================================
-- Generated: 2026-06-22
-- Cross-referenced against live database dump
--
-- WHAT THIS DOES:
--   1. Enriches User profiles (names, DOB, phone, address)
--   2. Differentiates Dentist specializations
--   3. Cleans up 3 duplicate Procedures, adds 7 new ones
--   4. Populates Dentist_Availability (30 rows — currently EMPTY)
--   5. Adds 12 new Appointments (Apr–Jun, mixed statuses)
--   6. Adds 8 new History records for completed appointments
--   7. Adds 10 new Payments (Paid + Unpaid, for analytics)
--
-- SAFE TO RUN: Uses UPDATE for existing rows, INSERT with
--   ON CONFLICT DO NOTHING for new rows, wrapped in transaction.
-- ============================================================

BEGIN;

-- ==========================================================
-- REFERENCE: Existing Account UUIDs
-- ==========================================================
-- patient_1  = 0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7
-- patient_2  = e256b769-81d1-4b8b-90f7-df5d6bf52d04
-- patient_3  = 1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4
-- dentist_1  = a32bdd65-315e-430e-b499-f1039b7ed81c
-- dentist_2  = b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e
-- dentist_3  = ffe1af4a-3f66-4383-98db-77c1ea6e6c6b
-- admin_1    = 28672106-6cad-41cb-8098-627378ccbd55
-- admin_2    = b3aecdd7-52ba-4e49-bcab-2de99a25b010
-- admin_3    = 373a0ec3-8b6d-45be-849a-037bc10dd7ef
--
-- Existing Procedure UUIDs (referenced by appointments):
-- Teeth Cleaning   = 504180df-9cb4-4ae6-b371-8f090e1b9bf1
-- Tooth Extraction  = 7e71225c-19b0-4d7f-8518-3cc78cbe2188
-- Teeth Whitening   = 5597dc3e-6be1-43c9-bfb4-67d643f3e73f


-- ==========================================================
-- 1. USER TABLE — Enrich existing profiles
-- ==========================================================

-- Patients
UPDATE "User" SET
  fullname = 'Maria Santos',
  date_of_birth = '1995-03-15',
  phone = 9171234567,
  address = '123 Rizal St, Quezon City'
WHERE user_id = '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7';

UPDATE "User" SET
  fullname = 'Juan Dela Cruz',
  date_of_birth = '1988-07-22',
  phone = 9189876543,
  address = '456 Mabini Ave, Makati City'
WHERE user_id = 'e256b769-81d1-4b8b-90f7-df5d6bf52d04';

UPDATE "User" SET
  fullname = 'Ana Reyes',
  date_of_birth = '2001-11-08',
  phone = 9201112233,
  address = '789 Bonifacio Rd, Taguig City'
WHERE user_id = '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4';

-- Dentists
UPDATE "User" SET
  fullname = 'Dr. Carlos Garcia',
  date_of_birth = '1980-01-10',
  phone = 9151234567,
  address = 'Toothy Dental Clinic, BGC, Taguig'
WHERE user_id = 'a32bdd65-315e-430e-b499-f1039b7ed81c';

UPDATE "User" SET
  fullname = 'Dr. Sophia Lim',
  date_of_birth = '1985-05-25',
  phone = 9161234567,
  address = 'Toothy Dental Clinic, BGC, Taguig'
WHERE user_id = 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e';

UPDATE "User" SET
  fullname = 'Dr. Marco Villanueva',
  date_of_birth = '1978-09-30',
  phone = 9171112233,
  address = 'Toothy Dental Clinic, BGC, Taguig'
WHERE user_id = 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b';

-- Admins
UPDATE "User" SET
  fullname = 'Rico Rodriguez',
  date_of_birth = '1990-06-01',
  phone = 9181234567,
  address = 'Toothy Clinic HQ, BGC, Taguig'
WHERE user_id = '28672106-6cad-41cb-8098-627378ccbd55';

UPDATE "User" SET
  fullname = 'Lea Fernandez',
  date_of_birth = '1992-04-15',
  phone = 9191234567,
  address = 'Toothy Clinic HQ, BGC, Taguig'
WHERE user_id = 'b3aecdd7-52ba-4e49-bcab-2de99a25b010';

UPDATE "User" SET
  fullname = 'Mark Bautista',
  date_of_birth = '1988-12-20',
  phone = 9201234567,
  address = 'Toothy Clinic HQ, BGC, Taguig'
WHERE user_id = '373a0ec3-8b6d-45be-849a-037bc10dd7ef';


-- ==========================================================
-- 1B. PATIENT TABLE — Enrich medical profiles
-- ==========================================================

UPDATE "Patient" SET
  allergies = 'Penicillin, Peanuts',
  medical_conditions = 'Hypertension',
  blood_type = 'A+',
  emergency_contact_name = 'Roberto Santos',
  emergency_contact_phone = '09179876543'
WHERE patient_id = '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7';

UPDATE "Patient" SET
  allergies = 'None',
  medical_conditions = 'Asthma',
  blood_type = 'O+',
  emergency_contact_name = 'Elena Dela Cruz',
  emergency_contact_phone = '09181112222'
WHERE patient_id = 'e256b769-81d1-4b8b-90f7-df5d6bf52d04';

UPDATE "Patient" SET
  allergies = 'Latex, Aspirin',
  medical_conditions = 'Type 1 Diabetes',
  blood_type = 'B-',
  emergency_contact_name = 'Miguel Reyes',
  emergency_contact_phone = '09205556677'
WHERE patient_id = '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4';


-- ==========================================================
-- 2. DENTIST TABLE — Differentiate specializations
-- ==========================================================

UPDATE "Dentist" SET
  specialization = 'General Dentistry',
  type = 'General Dentist',
  experience = '15 years',
  dental_school = 'UP College of Dentistry',
  graduation_year = '2011'
WHERE dentist_id = 'a32bdd65-315e-430e-b499-f1039b7ed81c';

UPDATE "Dentist" SET
  specialization = 'Orthodontics',
  type = 'Orthodontist',
  experience = '10 years',
  dental_school = 'UST Faculty of Dentistry',
  graduation_year = '2016'
WHERE dentist_id = 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e';

UPDATE "Dentist" SET
  specialization = 'Oral Surgery',
  type = 'Oral Surgeon',
  experience = '18 years',
  dental_school = 'CEU School of Dentistry',
  graduation_year = '2008'
WHERE dentist_id = 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b';


-- ==========================================================
-- 3. PROCEDURE TABLE — Clean duplicates + add new procedures
-- ==========================================================

-- Remove 3 unreferenced duplicate procedures
-- (These are NOT used by any appointment)
DELETE FROM "Procedure" WHERE procedure_id IN (
  'f00385b5-ffed-4e4e-af31-e91be2e44ca5',  -- dup Teeth Cleaning
  'c4698e7e-fe76-431c-8368-113753d7c383',  -- dup Teeth Whitening
  'de3d6ebb-f69c-491e-8c6a-8afb14f26095'   -- dup Tooth Extraction
);

-- Add 7 new procedures (total will be 10 unique)
INSERT INTO "Procedure" (
  procedure_id, procedure_name, procedure_description,
  category, pricing, "timeDuration", status,
  updated_by, created_at, updated_at
) VALUES
  (
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',
    'Dental Checkup',
    'Comprehensive oral examination and assessment of dental health.',
    'Preventive', 500, '15 mins', 'Active',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-04-01T08:00:00+00:00', '2026-04-01T08:00:00+00:00'
  ),
  (
    'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e',
    'Root Canal Treatment',
    'Endodontic treatment to remove infected pulp and save the tooth.',
    'Restorative', 12000, '120 mins', 'Active',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-04-01T08:00:00+00:00', '2026-04-01T08:00:00+00:00'
  ),
  (
    'c3d4e5f6-a7b8-4c9d-ae1f-2a3b4c5d6e7f',
    'Dental Filling',
    'Restoration of tooth structure using composite or amalgam materials.',
    'Restorative', 2000, '30 mins', 'Active',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-04-01T08:00:00+00:00', '2026-04-01T08:00:00+00:00'
  ),
  (
    'd4e5f6a7-b8c9-4d0e-9f2a-3b4c5d6e7f80',
    'Braces Installation',
    'Full orthodontic braces installation with brackets and wires.',
    'Orthodontic', 40000, '120 mins', 'Active',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-04-01T08:00:00+00:00', '2026-04-01T08:00:00+00:00'
  ),
  (
    'e5f6a7b8-c9d0-4e1f-aa3b-4c5d6e7f8091',
    'Braces Adjustment',
    'Monthly orthodontic adjustment and tightening of braces.',
    'Orthodontic', 2500, '30 mins', 'Active',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-04-01T08:00:00+00:00', '2026-04-01T08:00:00+00:00'
  ),
  (
    'f6a7b8c9-d0e1-4f2a-ab4c-5d6e7f809102',
    'Dental Crown',
    'Custom porcelain or ceramic crown placement for damaged teeth.',
    'Restorative', 15000, '90 mins', 'Active',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-04-01T08:00:00+00:00', '2026-04-01T08:00:00+00:00'
  ),
  (
    'a7b8c9d0-e1f2-4a3b-8c5d-6e7f80910213',
    'Dental X-Ray',
    'Panoramic or periapical X-ray imaging for diagnostic purposes.',
    'Diagnostic', 800, '15 mins', 'Active',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-04-01T08:00:00+00:00', '2026-04-01T08:00:00+00:00'
  )
ON CONFLICT (procedure_id) DO NOTHING;


-- ==========================================================
-- 4. DENTIST_AVAILABILITY TABLE — Weekly schedules
-- ==========================================================
-- Currently EMPTY. Populating for all 3 dentists.
--
-- dentist_1 (Dr. Garcia)    : Mon–Fri,  08:00–12:00 + 13:00–17:00
-- dentist_2 (Dr. Lim)       : Mon–Thu + Sat, 09:00–12:00 + 14:00–18:00
-- dentist_3 (Dr. Villanueva): Tue–Sat,  08:00–12:00 + 13:00–16:00

INSERT INTO "Dentist_Availability" (
  da_id, dentist_id, day, start_time, end_time, is_avail, updated_at
) VALUES
  -- === dentist_1: Dr. Carlos Garcia (Mon–Fri) ===
  ('da000001-0001-4000-a000-000000000001', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Monday',    '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000002', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Monday',    '13:00:00', '17:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000003', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Tuesday',   '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000004', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Tuesday',   '13:00:00', '17:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000005', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Wednesday', '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000006', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Wednesday', '13:00:00', '17:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000007', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Thursday',  '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000008', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Thursday',  '13:00:00', '17:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000009', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Friday',    '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000010', 'a32bdd65-315e-430e-b499-f1039b7ed81c', 'Friday',    '13:00:00', '17:00:00', true, NOW()),

  -- === dentist_2: Dr. Sophia Lim (Mon–Thu + Sat) ===
  ('da000001-0001-4000-a000-000000000011', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Monday',    '09:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000012', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Monday',    '14:00:00', '18:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000013', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Tuesday',   '09:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000014', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Tuesday',   '14:00:00', '18:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000015', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Wednesday', '09:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000016', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Wednesday', '14:00:00', '18:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000017', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Thursday',  '09:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000018', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Thursday',  '14:00:00', '18:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000019', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Saturday',  '09:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000020', 'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', 'Saturday',  '14:00:00', '18:00:00', true, NOW()),

  -- === dentist_3: Dr. Marco Villanueva (Tue–Sat) ===
  ('da000001-0001-4000-a000-000000000021', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Tuesday',   '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000022', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Tuesday',   '13:00:00', '16:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000023', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Wednesday', '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000024', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Wednesday', '13:00:00', '16:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000025', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Thursday',  '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000026', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Thursday',  '13:00:00', '16:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000027', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Friday',    '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000028', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Friday',    '13:00:00', '16:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000029', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Saturday',  '08:00:00', '12:00:00', true, NOW()),
  ('da000001-0001-4000-a000-000000000030', 'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', 'Saturday',  '13:00:00', '16:00:00', true, NOW())
ON CONFLICT (da_id) DO NOTHING;


-- ==========================================================
-- 5. APPOINTMENT TABLE — Spread across Apr/May/Jun for analytics
-- ==========================================================
-- Existing: 4 appointments (Jun 20–22). Adding 12 more.
-- Statuses used: Completed, Confirmed, Pending (matching app conventions)

INSERT INTO "Appointment" (
  appointment_id, patient_id, doctor_id, procedure_id,
  appointment_date, appointment_time, status, notes,
  updated_by, created_at, updated_at
) VALUES
  -- === PAST — Completed (April) ===
  (
    'aa000001-0001-4000-a000-000000000001',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1 (Maria)
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1 (Dr. Garcia)
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',  -- Dental Checkup
    '2026-04-15', '09:00:00', 'Completed',
    'Routine dental checkup',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-04-14T08:00:00+00:00', '2026-04-15T10:00:00+00:00'
  ),
  (
    'aa000001-0001-4000-a000-000000000002',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2 (Juan)
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e',  -- dentist_2 (Dr. Lim)
    'd4e5f6a7-b8c9-4d0e-9f2a-3b4c5d6e7f80',  -- Braces Installation
    '2026-04-28', '10:00:00', 'Completed',
    'Full braces installation — upper and lower',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-04-25T08:00:00+00:00', '2026-04-28T12:30:00+00:00'
  ),

  -- === PAST — Completed (May) ===
  (
    'aa000001-0001-4000-a000-000000000003',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1 (Maria)
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e',  -- dentist_2 (Dr. Lim)
    'c3d4e5f6-a7b8-4c9d-ae1f-2a3b4c5d6e7f',  -- Dental Filling
    '2026-05-05', '14:00:00', 'Completed',
    'Composite filling on upper premolar',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-05-03T08:00:00+00:00', '2026-05-05T15:00:00+00:00'
  ),
  (
    'aa000001-0001-4000-a000-000000000004',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2 (Juan)
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1 (Dr. Garcia)
    'a7b8c9d0-e1f2-4a3b-8c5d-6e7f80910213',  -- Dental X-Ray
    '2026-05-12', '10:00:00', 'Completed',
    'Panoramic X-ray — wisdom teeth assessment',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-05-10T08:00:00+00:00', '2026-05-12T10:30:00+00:00'
  ),
  (
    'aa000001-0001-4000-a000-000000000005',
    '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4',  -- patient_3 (Ana)
    'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b',  -- dentist_3 (Dr. Villanueva)
    'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e',  -- Root Canal Treatment
    '2026-05-20', '09:00:00', 'Completed',
    'Root canal treatment on lower molar #36',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-05-18T08:00:00+00:00', '2026-05-20T11:30:00+00:00'
  ),

  -- === PAST — Completed (June, before today) ===
  (
    'aa000001-0001-4000-a000-000000000006',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2 (Juan)
    'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b',  -- dentist_3 (Dr. Villanueva)
    'f6a7b8c9-d0e1-4f2a-ab4c-5d6e7f809102',  -- Dental Crown
    '2026-06-03', '13:00:00', 'Completed',
    'Porcelain crown on premolar #25',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-06-01T08:00:00+00:00', '2026-06-03T14:30:00+00:00'
  ),
  (
    'aa000001-0001-4000-a000-000000000007',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1 (Maria)
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1 (Dr. Garcia)
    '504180df-9cb4-4ae6-b371-8f090e1b9bf1',  -- Teeth Cleaning (existing)
    '2026-06-10', '08:00:00', 'Completed',
    'Deep cleaning and scaling session',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-06-08T08:00:00+00:00', '2026-06-10T09:00:00+00:00'
  ),
  (
    'aa000001-0001-4000-a000-000000000008',
    '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4',  -- patient_3 (Ana)
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1 (Dr. Garcia)
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',  -- Dental Checkup
    '2026-06-16', '10:00:00', 'Completed',
    'Routine checkup — all clear, gums healthy',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-06-14T08:00:00+00:00', '2026-06-16T10:30:00+00:00'
  ),

  -- === FUTURE — Confirmed ===
  (
    'aa000001-0001-4000-a000-000000000009',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1 (Maria)
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1 (Dr. Garcia)
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',  -- Dental Checkup
    '2026-06-24', '09:00:00', 'Confirmed',
    'Follow-up dental checkup',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-06-22T04:00:00+00:00', '2026-06-22T04:00:00+00:00'
  ),
  (
    'aa000001-0001-4000-a000-000000000010',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2 (Juan)
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e',  -- dentist_2 (Dr. Lim)
    'e5f6a7b8-c9d0-4e1f-aa3b-4c5d6e7f8091',  -- Braces Adjustment
    '2026-06-25', '14:00:00', 'Confirmed',
    'Monthly braces adjustment',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-06-22T04:00:00+00:00', '2026-06-22T04:00:00+00:00'
  ),

  -- === FUTURE — Pending ===
  (
    'aa000001-0001-4000-a000-000000000011',
    '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4',  -- patient_3 (Ana)
    'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b',  -- dentist_3 (Dr. Villanueva)
    '504180df-9cb4-4ae6-b371-8f090e1b9bf1',  -- Teeth Cleaning
    '2026-06-26', '10:00:00', 'Pending',
    'Teeth cleaning requested',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-06-22T04:00:00+00:00', '2026-06-22T04:00:00+00:00'
  ),
  (
    'aa000001-0001-4000-a000-000000000012',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1 (Maria)
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e',  -- dentist_2 (Dr. Lim)
    '5597dc3e-6be1-43c9-bfb4-67d643f3e73f',  -- Teeth Whitening (existing)
    '2026-06-28', '15:00:00', 'Pending',
    'Teeth whitening session requested',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-06-22T04:00:00+00:00', '2026-06-22T04:00:00+00:00'
  )
ON CONFLICT (appointment_id) DO NOTHING;


-- ==========================================================
-- 6. HISTORY TABLE — Records for all completed appointments
-- ==========================================================
-- Existing: 2 records (for existing completed appts).
-- Adding 8 for the new completed appointments above.

-- Update pre-existing history records with procedure_id
UPDATE "History" SET procedure_id = '504180df-9cb4-4ae6-b371-8f090e1b9bf1' WHERE history_id = '84a7e937-2965-4f30-add5-8120e89547cb';
UPDATE "History" SET procedure_id = '5597dc3e-6be1-43c9-bfb4-67d643f3e73f' WHERE history_id = '8c35d947-f047-4978-ae2d-ea81be4d89a7';

INSERT INTO "History" (
  history_id, patient_id, dentist_id, appointment_id, procedure_id,
  remarks, created_at
) VALUES
  (
    'bb000001-0001-4000-a000-000000000001',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1
    'aa000001-0001-4000-a000-000000000001',  -- Apr 15 Checkup
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',  -- Dental Checkup
    'Routine dental checkup completed. No cavities found. Gums are healthy. Recommended next visit in 6 months.',
    '2026-04-15T10:00:00+00:00'
  ),
  (
    'bb000001-0001-4000-a000-000000000002',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e',  -- dentist_2
    'aa000001-0001-4000-a000-000000000002',  -- Apr 28 Braces
    'd4e5f6a7-b8c9-4d0e-9f2a-3b4c5d6e7f80',  -- Braces Installation
    'Full braces installed — upper and lower arches. Metal brackets with NiTi wires. Patient advised on dietary restrictions and oral hygiene routine. First adjustment in 4 weeks.',
    '2026-04-28T12:30:00+00:00'
  ),
  (
    'bb000001-0001-4000-a000-000000000003',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e',  -- dentist_2
    'aa000001-0001-4000-a000-000000000003',  -- May 5 Filling
    'c3d4e5f6-a7b8-4c9d-ae1f-2a3b4c5d6e7f',  -- Dental Filling
    'Composite filling placed on upper premolar #14. Decay was moderate. No complications. Patient to avoid hard food for 24 hours.',
    '2026-05-05T15:00:00+00:00'
  ),
  (
    'bb000001-0001-4000-a000-000000000004',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1
    'aa000001-0001-4000-a000-000000000004',  -- May 12 X-Ray
    'a7b8c9d0-e1f2-4a3b-8c5d-6e7f80910213',  -- Dental X-Ray
    'Panoramic X-ray completed. Impacted wisdom teeth on both lower sides (#38, #48). Surgical extraction recommended. Referred to Dr. Villanueva for oral surgery consultation.',
    '2026-05-12T10:30:00+00:00'
  ),
  (
    'bb000001-0001-4000-a000-000000000005',
    '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4',  -- patient_3
    'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b',  -- dentist_3
    'aa000001-0001-4000-a000-000000000005',  -- May 20 Root Canal
    'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e',  -- Root Canal Treatment
    'Root canal treatment on lower molar #36 completed successfully. Three canals identified and filled. Temporary crown placed. Prescribed Amoxicillin 500mg TID for 7 days. Permanent crown to be placed in 2 weeks.',
    '2026-05-20T11:30:00+00:00'
  ),
  (
    'bb000001-0001-4000-a000-000000000006',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2
    'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b',  -- dentist_3
    'aa000001-0001-4000-a000-000000000006',  -- Jun 3 Crown
    'f6a7b8c9-d0e1-4f2a-ab4c-5d6e7f809102',  -- Dental Crown
    'Porcelain crown placed on premolar #25. Good fit and bite alignment verified. Patient advised to avoid sticky foods and hard chewing for 48 hours.',
    '2026-06-03T14:30:00+00:00'
  ),
  (
    'bb000001-0001-4000-a000-000000000007',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1
    'aa000001-0001-4000-a000-000000000007',  -- Jun 10 Cleaning
    '504180df-9cb4-4ae6-b371-8f090e1b9bf1',  -- Teeth Cleaning
    'Deep cleaning and scaling completed. Minor tartar buildup removed from lower anteriors. No bleeding, gums in good condition.',
    '2026-06-10T09:00:00+00:00'
  ),
  (
    'bb000001-0001-4000-a000-000000000008',
    '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4',  -- patient_3
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1
    'aa000001-0001-4000-a000-000000000008',  -- Jun 16 Checkup
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',  -- Dental Checkup
    'Routine checkup. All teeth in good condition. Root canal site on #36 healing well. Permanent crown secure. Next visit in 6 months.',
    '2026-06-16T10:30:00+00:00'
  )
ON CONFLICT (history_id) DO NOTHING;


-- ==========================================================
-- 7. PAYMENTS TABLE — Revenue records for analytics
-- ==========================================================
-- Existing: 2 records (Jun 20: ₱1500, Jun 21: ₱4500). Adding 10 more.
-- paid_for = dentist_id (matches existing data pattern)
-- Mix of Paid + Unpaid for realistic analytics

-- Update pre-existing payment records with appointment_id and procedure_id
UPDATE "Payments" SET
  appointment_id = 'f643e25d-bb89-4089-a2a4-fccca7ef1e31',
  procedure_id = '504180df-9cb4-4ae6-b371-8f090e1b9bf1'
WHERE id = '2fe6ebad-7907-42fe-bdcb-93b5860ad8e1';

UPDATE "Payments" SET
  appointment_id = 'ff9c3a37-56e6-4258-86d1-cc0a08e6c7ca',
  procedure_id = '5597dc3e-6be1-43c9-bfb4-67d643f3e73f'
WHERE id = 'e963bc18-2921-4fa2-abfe-e68d904791ea';

INSERT INTO "Payments" (
  id, paid_by, paid_for, amount, status, appointment_id, procedure_id, created_at
) VALUES
  -- April payments
  (
    'cc000001-0001-4000-a000-000000000001',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1
    500, 'Paid',
    'aa000001-0001-4000-a000-000000000001',  -- Apr 15 Checkup
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',  -- Dental Checkup
    '2026-04-15T10:00:00+00:00'
  ),
  (
    'cc000001-0001-4000-a000-000000000002',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e',  -- dentist_2
    40000, 'Paid',
    'aa000001-0001-4000-a000-000000000002',  -- Apr 28 Braces
    'd4e5f6a7-b8c9-4d0e-9f2a-3b4c5d6e7f80',  -- Braces Installation
    '2026-04-28T12:30:00+00:00'
  ),

  -- May payments
  (
    'cc000001-0001-4000-a000-000000000003',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e',  -- dentist_2
    2000, 'Paid',
    'aa000001-0001-4000-a000-000000000003',  -- May 5 Filling
    'c3d4e5f6-a7b8-4c9d-ae1f-2a3b4c5d6e7f',  -- Dental Filling
    '2026-05-05T15:00:00+00:00'
  ),
  (
    'cc000001-0001-4000-a000-000000000004',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1
    800, 'Paid',
    'aa000001-0001-4000-a000-000000000004',  -- May 12 X-Ray
    'a7b8c9d0-e1f2-4a3b-8c5d-6e7f80910213',  -- Dental X-Ray
    '2026-05-12T10:30:00+00:00'
  ),
  (
    'cc000001-0001-4000-a000-000000000005',
    '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4',  -- patient_3
    'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b',  -- dentist_3
    12000, 'Paid',
    'aa000001-0001-4000-a000-000000000005',  -- May 20 Root Canal
    'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e',  -- Root Canal Treatment
    '2026-05-20T11:30:00+00:00'
  ),

  -- June payments (past)
  (
    'cc000001-0001-4000-a000-000000000006',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2
    'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b',  -- dentist_3
    15000, 'Paid',
    'aa000001-0001-4000-a000-000000000006',  -- Jun 3 Crown
    'f6a7b8c9-d0e1-4f2a-ab4c-5d6e7f809102',  -- Dental Crown
    '2026-06-03T14:30:00+00:00'
  ),
  (
    'cc000001-0001-4000-a000-000000000007',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1
    1500, 'Paid',
    'aa000001-0001-4000-a000-000000000007',  -- Jun 10 Cleaning
    '504180df-9cb4-4ae6-b371-8f090e1b9bf1',  -- Teeth Cleaning
    '2026-06-10T09:00:00+00:00'
  ),
  (
    'cc000001-0001-4000-a000-000000000008',
    '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4',  -- patient_3
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1
    500, 'Paid',
    'aa000001-0001-4000-a000-000000000008',  -- Jun 16 Checkup
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',  -- Dental Checkup
    '2026-06-16T10:30:00+00:00'
  ),

  -- Future appointments — Unpaid (for testing unpaid flows)
  (
    'cc000001-0001-4000-a000-000000000009',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7',  -- patient_1
    'a32bdd65-315e-430e-b499-f1039b7ed81c',  -- dentist_1
    500, 'Unpaid',
    'aa000001-0001-4000-a000-000000000009',  -- Checkup Jun 24
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',  -- Dental Checkup
    '2026-06-22T04:00:00+00:00'
  ),
  (
    'cc000001-0001-4000-a000-000000000010',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04',  -- patient_2
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e',  -- dentist_2
    2500, 'Unpaid',
    'aa000001-0001-4000-a000-000000000010',  -- Braces Adj Jun 25
    'e5f6a7b8-c9d0-4e1f-aa3b-4c5d6e7f8091',  -- Braces Adjustment
    '2026-06-22T04:00:00+00:00'
  )
ON CONFLICT (id) DO NOTHING;


-- ==========================================================
-- 8. LEAVE_REQUEST TABLE — Dentist leaves/vacations
-- ==========================================================

INSERT INTO "Leave_Request" (
  request_id, dentist_id, start_date, end_date, reason, status, reviewed_by, created_at, updated_at
) VALUES
  (
    'dd000001-0001-4000-a000-000000000001',
    'a32bdd65-315e-430e-b499-f1039b7ed81c', -- dentist_1 (Dr. Garcia)
    '2026-07-01', '2026-07-05',
    'Annual family vacation',
    'Approved',
    '28672106-6cad-41cb-8098-627378ccbd55', -- admin_1 (Rico)
    '2026-06-20T08:00:00+00:00', '2026-06-21T09:00:00+00:00'
  ),
  (
    'dd000001-0001-4000-a000-000000000002',
    'b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e', -- dentist_2 (Dr. Lim)
    '2026-07-10', '2026-07-12',
    'Attending Philippine Dental Association Convention',
    'Approved',
    '28672106-6cad-41cb-8098-627378ccbd55',
    '2026-06-21T10:00:00+00:00', '2026-06-21T11:00:00+00:00'
  ),
  (
    'dd000001-0001-4000-a000-000000000003',
    'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', -- dentist_3 (Dr. Villanueva)
    '2026-07-20', '2026-07-22',
    'Personal emergency leave',
    'Pending',
    NULL,
    '2026-06-22T08:00:00+00:00', '2026-06-22T08:00:00+00:00'
  )
ON CONFLICT (request_id) DO NOTHING;


-- ==========================================================
-- 9. NOTIFICATION TABLE — In-app notifications
-- ==========================================================

INSERT INTO "Notification" (
  notification_id, user_id, title, body, type, reference_id, is_read, created_at
) VALUES
  (
    'ee000001-0001-4000-a000-000000000001',
    '0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7', -- patient_1 (Maria Santos)
    'Appointment Confirmed',
    'Your appointment for Dental Checkup with Dr. Carlos Garcia on June 24 at 09:00 AM has been confirmed.',
    'status_change',
    'aa000001-0001-4000-a000-000000000009',
    false,
    '2026-06-22T04:00:00+00:00'
  ),
  (
    'ee000001-0001-4000-a000-000000000002',
    'e256b769-81d1-4b8b-90f7-df5d6bf52d04', -- patient_2 (Juan Dela Cruz)
    'Appointment Reminder',
    'Friendly reminder: You have an upcoming appointment for Braces Adjustment with Dr. Sophia Lim tomorrow at 02:00 PM.',
    'appointment_reminder',
    'aa000001-0001-4000-a000-000000000010',
    false,
    '2026-06-22T04:00:00+00:00'
  ),
  (
    'ee000001-0001-4000-a000-000000000003',
    'ffe1af4a-3f66-4383-98db-77c1ea6e6c6b', -- dentist_3 (Dr. Villanueva)
    'New Appointment Booking',
    'A new appointment for Root Canal Treatment has been booked by Ana Reyes for May 20 at 09:00 AM.',
    'booking_confirmed',
    'aa000001-0001-4000-a000-000000000005',
    true,
    '2026-05-18T08:00:00+00:00'
  ),
  (
    'ee000001-0001-4000-a000-000000000004',
    'a32bdd65-315e-430e-b499-f1039b7ed81c', -- dentist_1 (Dr. Garcia)
    'Leave Request Approved',
    'Your leave request for July 1 to July 5 has been approved by Rico Rodriguez.',
    'leave_approved',
    'dd000001-0001-4000-a000-000000000001',
    false,
    '2026-06-21T09:00:00+00:00'
  ),
  (
    'ee000001-0001-4000-a000-000000000005',
    '1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4', -- patient_3 (Ana Reyes)
    'System Announcement',
    'Welcome to the new Toothy Clinic app! You can now track your treatment history and view estimated costs.',
    'general',
    NULL,
    false,
    '2026-06-22T08:00:00+00:00'
  )
ON CONFLICT (notification_id) DO NOTHING;


COMMIT;

-- ==========================================================
-- VERIFICATION QUERIES (run after seed to confirm)
-- ==========================================================
-- SELECT 'User' AS tbl, COUNT(*) AS rows FROM "User"
-- UNION ALL SELECT 'Patient', COUNT(*) FROM "Patient"
-- UNION ALL SELECT 'Dentist', COUNT(*) FROM "Dentist"
-- UNION ALL SELECT 'Procedure', COUNT(*) FROM "Procedure"
-- UNION ALL SELECT 'Dentist_Availability', COUNT(*) FROM "Dentist_Availability"
-- UNION ALL SELECT 'Appointment', COUNT(*) FROM "Appointment"
-- UNION ALL SELECT 'History', COUNT(*) FROM "History"
-- UNION ALL SELECT 'Payments', COUNT(*) FROM "Payments"
-- UNION ALL SELECT 'Leave_Request', COUNT(*) FROM "Leave_Request"
-- UNION ALL SELECT 'Notification', COUNT(*) FROM "Notification"
-- ORDER BY tbl;
--
-- EXPECTED COUNTS:
--   User:                  9 (unchanged)
--   Patient:               3 (unchanged, but enriched)
--   Dentist:               3 (unchanged, but enriched)
--   Procedure:            10 (was 6, removed 3 dupes, added 7)
--   Dentist_Availability: 30 (was 0)
--   Appointment:          16 (was 4, added 12)
--   History:              10 (was 2, added 8)
--   Payments:             12 (was 2, added 10)
--   Leave_Request:         3 (was 0)
--   Notification:          5 (was 0)
