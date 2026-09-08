# Toothy Clinic App v2.0 - Complete Functionality Walkthrough

Welcome to the Toothy Clinic App v2.0 testing guide. This document provides step-by-step instructions to verify every major functionality across the three system roles: **Patient**, **Dentist**, and **Admin**.

---

## 🔑 Test Accounts & Roles

Use the following credentials to sign in and test each role:

| Role | Email | Password | Primary Workflow Page |
| :--- | :--- | :--- | :--- |
| **Patient** | `patient_1@gmail.com` | `patient_1password` | My Care Hub (Home, Costs, Bookings) |
| **Dentist** | `dentist_1@gmail.com` | `dentist_1password` | Dentist Workspaces (Schedules, Leaves, Treatments) |
| **Admin** | `admin_1@gmail.com` | `admin_1password` | Workflow Control (Approvals, Users, Procedures) |

---

## 📋 Role 1: Patient Functionality Walkthrough

Patients use the app to book appointments, view costs, read alerts, and maintain their medical records.

### Step 1: Login & Access Care Hub
1. Launch the app and sign in as `patient_1@gmail.com` / `patient_1password`.
2. Tap the **Workflow** icon (second tab from the left) on the bottom navbar to open **My Care Hub**.

### Step 2: Book an Appointment
1. In the Care Hub, click **Book Appointment**.
2. Select a date from the calendar (e.g. July 15, 2026).
3. Select an available time slot and choose a Dentist (e.g. *Dr. Carlos Garcia*).
4. Add notes (e.g., *"Routine checkup and minor teeth cleaning"*).
5. Click **Confirm Booking**. Verify that a booking confirmation notification is fired, and the appointment appears in your list under **My Appointments** as **Pending** or **Confirmed**.

### Step 3: Check Procedure Cost Transparency
1. Go back to **My Care Hub**.
2. Click **Procedure Costs**.
3. Scroll through the services (e.g., *Teeth Cleaning*, *Teeth Whitening*, *Tooth Extraction*) and verify their estimated prices are visible (Read-Only).

### Step 4: Manage In-App Notifications
1. Click the **Notifications** tab (third tab from the left) on the bottom navbar.
2. Verify you see booking updates. Tapping any unread notification clears its unread blue dot and updates its read status.

### Step 5: Update Medical Records
1. Click the **Profile** tab (fourth tab from the left) on the bottom navbar.
2. Tap the **View Records** card below your profile badge.
3. Verify your current medical stats load (Blood Type, Allergies, etc.).
4. Tap **Edit Details**. Change your blood type, add an allergy (e.g., *"Penicillin"*), and edit your emergency contact details.
5. Tap **Save**. Verify the SnackBar confirms the update, and the new stats persist in the display.

---

## 📋 Role 2: Dentist Functionality Walkthrough

Dentists use the app to check their calendar, log treatment notes, check analytics, and manage leaves.

### Step 1: Login & Access Workspace
1. Sign in as `dentist_1@gmail.com` / `dentist_1password`.
2. Tap the **Workflow** icon on the bottom navbar to open **Dentist Workspaces**.

### Step 2: Dentist Scheduling Availability
1. In the workspace, click **My Schedule**.
2. Select your active working days and specific hours (e.g. *Monday, Wednesday 9:00 AM - 5:00 PM*).
3. Tap **Save Schedule** to sync your availability.

### Step 3: File a Leave Request
1. Go back to **Dentist Workspaces**.
2. Under **My Leave Requests**, verify you see previous leaves.
3. File a new leave by selecting a start date, end date, and entering a reason (e.g., *" PDA Seminar "*).
4. Tap **Submit Request**. Verify it appears in your list as **PENDING**.
5. *Optional Cancellation*: Tap **Cancel Request** on the pending leave request card. Verify it is deleted from the screen and the database.

### Step 4: Log Patient Treatment Notes
1. Go to **Dentist Workspaces**.
2. Click **Treatment Entry** to view patients.
3. Select a patient (e.g. *Maria Santos*) and tap **Add Treatment**.
4. Choose the procedure performed, input dentist remarks, and save the treatment card. Verify it links to the patient's medical file.

### Step 5: Analytics and Fulfillment
1. Tap **My Analytics** or **Fulfillment Rate** in your workspace.
2. Review charts detailing your performed treatments, monthly revenue graphs, and fulfillment statistics.

---

## 📋 Role 3: Admin Functionality Walkthrough

Admins have full oversight of clinic operations, registration applications, leaves, and procedures.

### Step 1: Login & Access Control
1. Sign in as `admin_1@gmail.com` / `admin_1password`.
2. Tap the **Workflow** icon on the bottom navbar to open **Workflow Control**.

### Step 2: Approve Dentist Leaves
1. In the Workflow Control panel, scroll to the **Dentist Leave Approvals** section.
2. Locate the pending leave request card for **Dr. Marco Villanueva** (Reason: *Personal emergency leave*).
3. Click the green **Approve** button.
4. Verify:
   *   The status badge changes to **APPROVED**.
   *   Dr. Villanueva receives a notification in his inbox.

### Step 3: Approve Dentist Registrations
1. In Workflow Control, click **Dentist Requests**.
2. Select a pending application, review their credentials, and click **Approve**.
3. Verify the dentist's role is activated and they can now sign in.

### Step 4: Add / Edit Procedures
1. In Workflow Control, click **Procedures**.
2. **Add**: Click the **"+"** icon in the top right. Enter details for a new procedure (e.g., *"Root Canal (Surgical)"*, Price: *₱6,000*) and save.
3. **Edit**: Click **Edit** on any procedure card, adjust the price, and save. Verify the update shows on the list.

### Step 5: Assign User Roles
1. In Workflow Control, click **User Roles**.
2. Search for any user (e.g. *patient_3@gmail.com*).
3. Expand their card and change their type to **Dentist** or **Admin**. Select their specialization and verify their role tag updates.

### Step 6: Database Analytics & Revenue History
1. Tap the **Home** icon on the bottom navbar.
2. Verify that the **Monthly Revenue**, **Total Patients**, and **Fulfillment Rate** cards display live database calculations instead of static mock numbers.
3. Tap the **Monthly Revenue Card**. Verify that it opens the **Total Revenue** page.
4. Tap the choice chips filters ('7D', '1M', '3M', '6M', 'All') and verify that the revenue graph, period comparison metrics, and growth indicators recalculate dynamically using real database records.

