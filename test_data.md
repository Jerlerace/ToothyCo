# Toothy Clinic App — Test Data Reference

This file documents all test data seeded into the Supabase database for QA and development purposes.

---

## Test Accounts (Auth + User Table)

| Role | Email | Password | UUID | Full Name | DOB | Phone | Address |
|------|-------|----------|------|-----------|-----|-------|---------|
| **Patient** | `patient_1@gmail.com` | `patient_1password` | `0fe30be8-6b05-4bb6-9d3e-a60e20fe5ce7` | Maria Santos | 1995-03-15 | 9171234567 | 123 Rizal St, Quezon City |
| **Patient** | `patient_2@gmail.com` | `patient_2password` | `e256b769-81d1-4b8b-90f7-df5d6bf52d04` | Juan Dela Cruz | 1988-07-22 | 9189876543 | 456 Mabini Ave, Makati City |
| **Patient** | `patient_3@gmail.com` | `patient_3password` | `1c6fcd1d-40db-4b8f-9ce7-adf6a390dda4` | Ana Reyes | 2001-11-08 | 9201112233 | 789 Bonifacio Rd, Taguig City |
| **Dentist** | `dentist_1@gmail.com` | `dentist_1password` | `a32bdd65-315e-430e-b499-f1039b7ed81c` | Dr. Carlos Garcia | 1980-01-10 | 9151234567 | Toothy Dental Clinic, BGC |
| **Dentist** | `dentist_2@gmail.com` | `dentist_2password` | `b6ff2ddb-41b3-4b59-a0c7-c2948a117f0e` | Dr. Sophia Lim | 1985-05-25 | 9161234567 | Toothy Dental Clinic, BGC |
| **Dentist** | `dentist_3@gmail.com` | `dentist_3password` | `ffe1af4a-3f66-4383-98db-77c1ea6e6c6b` | Dr. Marco Villanueva | 1978-09-30 | 9171112233 | Toothy Dental Clinic, BGC |
| **Admin** | `admin_1@gmail.com` | `admin_1password` | `28672106-6cad-41cb-8098-627378ccbd55` | Rico Rodriguez | 1990-06-01 | 9181234567 | Toothy Clinic HQ, BGC |
| **Admin** | `admin_2@gmail.com` | `admin_2password` | `b3aecdd7-52ba-4e49-bcab-2de99a25b010` | Lea Fernandez | 1992-04-15 | 9191234567 | Toothy Clinic HQ, BGC |
| **Admin** | `admin_3@gmail.com` | `admin_3password` | `373a0ec3-8b6d-45be-849a-037bc10dd7ef` | Mark Bautista | 1988-12-20 | 9201234567 | Toothy Clinic HQ, BGC |
---

## Patient Medical Profiles

| Patient | Allergies | Medical Conditions | Blood Type | Emergency Contact | Emergency Phone |
|---------|-----------|--------------------|------------|-------------------|-----------------|
| Maria Santos | Penicillin, Peanuts | Hypertension | A+ | Roberto Santos (Spouse) | 09179876543 |
| Juan Dela Cruz | None | Asthma | O+ | Elena Dela Cruz (Mother) | 09181112222 |
| Ana Reyes | Latex, Aspirin | Type 1 Diabetes | B- | Miguel Reyes (Father) | 09205556677 |

---

## Dentist Profiles

| Dentist | Specialization | Type | Experience | Dental School | Graduation |
|---------|---------------|------|------------|---------------|------------|
| Dr. Carlos Garcia | General Dentistry | General Dentist | 15 years | UP College of Dentistry | 2011 |
| Dr. Sophia Lim | Orthodontics | Orthodontist | 10 years | UST Faculty of Dentistry | 2016 |
| Dr. Marco Villanueva | Oral Surgery | Oral Surgeon | 18 years | CEU School of Dentistry | 2008 |

---

## Procedures (10 total)

| Procedure | Category | Price (₱) | Duration | Status |
|-----------|----------|-----------|----------|--------|
| Teeth Cleaning | Preventive | 1,500 | 30 mins | Active |
| Dental Checkup | Preventive | 500 | 15 mins | Active |
| Tooth Extraction | Surgery | 2,500 | 45 mins | Active |
| Teeth Whitening | Cosmetic | 4,500 | 1 hr | Active |
| Root Canal Treatment | Restorative | 12,000 | 120 mins | Active |
| Dental Filling | Restorative | 2,000 | 30 mins | Active |
| Braces Installation | Orthodontic | 40,000 | 120 mins | Active |
| Braces Adjustment | Orthodontic | 2,500 | 30 mins | Active |
| Dental Crown | Restorative | 15,000 | 90 mins | Active |
| Dental X-Ray | Diagnostic | 800 | 15 mins | Active |

---

## Dentist Availability (30 time blocks)

| Dentist | Days | Morning | Afternoon |
|---------|------|---------|-----------|
| Dr. Garcia | Mon–Fri | 08:00–12:00 | 13:00–17:00 |
| Dr. Lim | Mon–Thu + Sat | 09:00–12:00 | 14:00–18:00 |
| Dr. Villanueva | Tue–Sat | 08:00–12:00 | 13:00–16:00 |

---

## Appointments (16 total)

### Pre-existing (4)

| Date | Patient | Dentist | Procedure | Status |
|------|---------|---------|-----------|--------|
| Jun 20 | Juan Dela Cruz | Dr. Garcia | Teeth Cleaning | Completed |
| Jun 21 | Ana Reyes | Dr. Lim | Teeth Whitening | Completed |
| Jun 21 | Maria Santos | Dr. Villanueva | Tooth Extraction | No Show |
| Jun 22 | Juan Dela Cruz | Dr. Lim | Tooth Extraction | Cancelled |

### Newly Seeded — Past/Completed (8)

| Date | Patient | Dentist | Procedure | Status |
|------|---------|---------|-----------|--------|
| Apr 15 | Maria Santos | Dr. Garcia | Dental Checkup | Completed |
| Apr 28 | Juan Dela Cruz | Dr. Lim | Braces Installation | Completed |
| May 05 | Maria Santos | Dr. Lim | Dental Filling | Completed |
| May 12 | Juan Dela Cruz | Dr. Garcia | Dental X-Ray | Completed |
| May 20 | Ana Reyes | Dr. Villanueva | Root Canal Treatment | Completed |
| Jun 03 | Juan Dela Cruz | Dr. Villanueva | Dental Crown | Completed |
| Jun 10 | Maria Santos | Dr. Garcia | Teeth Cleaning | Completed |
| Jun 16 | Ana Reyes | Dr. Garcia | Dental Checkup | Completed |

### Newly Seeded — Future (4)

| Date | Patient | Dentist | Procedure | Status |
|------|---------|---------|-----------|--------|
| Jun 24 | Maria Santos | Dr. Garcia | Dental Checkup | Confirmed |
| Jun 25 | Juan Dela Cruz | Dr. Lim | Braces Adjustment | Confirmed |
| Jun 26 | Ana Reyes | Dr. Villanueva | Teeth Cleaning | Pending |
| Jun 28 | Maria Santos | Dr. Lim | Teeth Whitening | Pending |

---

## Payment Records (12 total)

| Date | Patient | Dentist | Amount (₱) | Status | Linked Appointment & Procedure |
|------|---------|---------|------------|--------|--------------------------------|
| Apr 15 | Maria Santos | Dr. Garcia | 500 | Paid | Apr 15 Checkup — Dental Checkup |
| Apr 28 | Juan Dela Cruz | Dr. Lim | 40,000 | Paid | Apr 28 Braces — Braces Installation |
| May 05 | Maria Santos | Dr. Lim | 2,000 | Paid | May 05 Filling — Dental Filling |
| May 12 | Juan Dela Cruz | Dr. Garcia | 800 | Paid | May 12 X-Ray — Dental X-Ray |
| May 20 | Ana Reyes | Dr. Villanueva | 12,000 | Paid | May 20 Root Canal — Root Canal Treatment |
| Jun 03 | Juan Dela Cruz | Dr. Villanueva | 15,000 | Paid | Jun 03 Crown — Dental Crown |
| Jun 10 | Maria Santos | Dr. Garcia | 1,500 | Paid | Jun 10 Cleaning — Teeth Cleaning |
| Jun 16 | Ana Reyes | Dr. Garcia | 500 | Paid | Jun 16 Checkup — Dental Checkup |
| Jun 20 | Juan Dela Cruz | Dr. Garcia | 1,500 | Paid | Jun 20 Cleaning — Teeth Cleaning (Pre-existing) |
| Jun 21 | Ana Reyes | Dr. Lim | 4,500 | Paid | Jun 21 Whitening — Teeth Whitening (Pre-existing) |
| Jun 22 | Maria Santos | Dr. Garcia | 500 | Unpaid | Jun 24 Checkup — Dental Checkup (Future) |
| Jun 22 | Juan Dela Cruz | Dr. Lim | 2,500 | Unpaid | Jun 25 Braces Adj — Braces Adjustment (Future) |

### Revenue Summary

| Month | Total Revenue (₱) | # Paid Transactions |
|-------|-------------------|---------------------|
| April 2026 | 40,500 | 2 |
| May 2026 | 14,800 | 3 |
| June 2026 | 23,000 | 5 |
| **Total** | **₱78,300** | **10** |

---

## Treatment History (10 total)

| Patient | Dentist | Procedure | Remarks | Date |
|---------|---------|-----------|---------|------|
| Maria Santos | Dr. Garcia | Dental Checkup | Routine dental checkup completed. No cavities found. Gums are healthy. Recommended next visit in 6 months. | Apr 15 |
| Juan Dela Cruz | Dr. Lim | Braces Installation | Full braces installed — upper and lower arches. Metal brackets with NiTi wires. Patient advised on dietary restrictions and oral hygiene routine. First adjustment in 4 weeks. | Apr 28 |
| Maria Santos | Dr. Lim | Dental Filling | Composite filling placed on upper premolar #14. Decay was moderate. No complications. Patient to avoid hard food for 24 hours. | May 05 |
| Juan Dela Cruz | Dr. Garcia | Dental X-Ray | Panoramic X-ray completed. Impacted wisdom teeth on both lower sides (#38, #48). Surgical extraction recommended. Referred to Dr. Villanueva for oral surgery consultation. | May 12 |
| Ana Reyes | Dr. Villanueva | Root Canal Treatment | Root canal treatment on lower molar #36 completed successfully. Three canals identified and filled. Temporary crown placed. Prescribed Amoxicillin 500mg TID for 7 days. Permanent crown to be placed in 2 weeks. | May 20 |
| Juan Dela Cruz | Dr. Villanueva | Dental Crown | Porcelain crown placed on premolar #25. Good fit and bite alignment verified. Patient advised to avoid sticky foods and hard chewing for 48 hours. | Jun 03 |
| Maria Santos | Dr. Garcia | Teeth Cleaning | Deep cleaning and scaling completed. Minor tartar buildup removed from lower anteriors. No bleeding, gums in good condition. | Jun 10 |
| Ana Reyes | Dr. Garcia | Dental Checkup | Routine checkup. All teeth in good condition. Root canal site on #36 healing well. Permanent crown secure. Next visit in 6 months. | Jun 16 |
| Juan Dela Cruz | Dr. Garcia | Teeth Cleaning | Cleaned tartar. (Pre-existing) | Jun 20 |
| Ana Reyes | Dr. Lim | Teeth Whitening | Bleaching done. (Pre-existing) | Jun 21 |

---

## Dentist Leave Requests (3 total)

| Dentist | Start Date | End Date | Reason | Status | Reviewed By |
|---------|------------|----------|--------|--------|-------------|
| Dr. Carlos Garcia | 2026-07-01 | 2026-07-05 | Annual family vacation | Approved | Rico Rodriguez |
| Dr. Sophia Lim | 2026-07-10 | 2026-07-12 | Attending Philippine Dental Association Convention | Approved | Rico Rodriguez |
| Dr. Marco Villanueva | 2026-07-20 | 2026-07-22 | Personal emergency leave | Pending | - |

---

## In-App Notifications (5 total)

| Recipient | Title | Body | Type | Reference | Status |
|-----------|-------|------|------|-----------|--------|
| Maria Santos | Appointment Confirmed | Your appointment for Dental Checkup with Dr. Carlos Garcia on June 24 at 09:00 AM has been confirmed. | status_change | Appointment 9 | Unread |
| Juan Dela Cruz | Appointment Reminder | Friendly reminder: You have an upcoming appointment for Braces Adjustment with Dr. Sophia Lim tomorrow at 02:00 PM. | appointment_reminder | Appointment 10 | Unread |
| Dr. Marco Villanueva | New Appointment Booking | A new appointment for Root Canal Treatment has been booked by Ana Reyes for May 20 at 09:00 AM. | booking_confirmed | Appointment 5 | Read |
| Dr. Carlos Garcia | Leave Request Approved | Your leave request for July 1 to July 5 has been approved by Rico Rodriguez. | leave_approved | Leave Request 1 | Unread |
| Ana Reyes | System Announcement | Welcome to the new Toothy Clinic app! You can now track your treatment history and view estimated costs. | general | - | Unread |

---

> [!NOTE]
> This data was seeded on June 22, 2026 using `test_data_seed.sql`. All accounts are active and immediately usable.
