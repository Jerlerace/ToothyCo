# Toothy Clinic App - v2.0 Dentist Functionality Walkthrough

This document provides a step-by-step guide on how to manually verify every single functionality designed for the **Dentist / Doctor** role in the v2.0 release of the Toothy Clinic App.

---

## 1. Authentication & Role-Based Routing (TC001 / TC002)

### Description
Dentists must securely log in to the application and be automatically routed to their role-specific landing dashboard, with all headers and interfaces personalized to their profile.

### Step-by-Step Execution
1. Open the app to the landing page.
2. Tap the **Log In** button.
3. Input the dentist credentials:
   - **Email**: `doctor@gmail.com`
   - **Password**: `doctor`
4. Click **Sign In**.
5. **Expected Output**:
   - The user is logged in successfully and redirected to the unified landing screen (`Homepage_Unified`).
   - The top header dynamically displays a personalized greeting with the logged-in doctor's fullname: `'Hello, Dr. John Doe 👋'` (replaces the old static `'Dr. Smith'` greeting).

---

## 2. Dynamic Profile Customization & Badge (Tab 4)

### Description
The Profile tab dynamically adapts its metadata, badges, and layout depending on the role of the logged-in user.

### Step-by-Step Execution
1. From the unified homepage bottom navigation bar, click the **Profile** icon (rightmost tab).
2. **Expected Output**:
   - The profile screen displays the logged-in dentist's name (`John Doe`) and email (`doctor@gmail.com`).
   - A custom green role badge is rendered stating **Dentist** (with dynamic green borders and background styling, replacing the hardcoded "Administrator" label).
3. Tap **Edit Profile Info**, **Change Email Address**, or **Change Security Password** to manage security and credentials.

---

## 3. Dentist Availability & Schedule Management (TC004)

### Description
Dentists can define their active weekly working days and set specific start/end timing blocks for clinic presence.

### Step-by-Step Execution
1. Grid the **Workflow** tab icon (second from left).
2. Under **Dentist Workspaces**, click the **My Schedule** card.
3. On the schedule page, modify availability options:
   - Toggle the active working days of the week (e.g., Monday through Friday).
   - Tap the **Start Time** or **End Time** fields to open the clock picker and adjust the hours (e.g., `09:00 AM` to `05:00 PM`).
4. Click the **Save Availability** button.
5. **Expected Output**:
   - A SnackBar message saying `"Saving availability..."` followed by `"Availability saved successfully!"` is shown.
   - Availability updates are written to the `Dentist_Availability` table in Supabase.

---

## 4. Leave & Vacation Filing (TC004 - Leave_Request Table)

### Description
Dentists can file leave or vacation requests spanning multiple dates, which are saved in the new database schema for Admin approval. They can monitor requests and cancel them while pending.

### Step-by-Step Execution
1. Inside the **My Schedule** page, scroll down to the **Leave & Vacation** section.
2. Click the **+** (add) icon button.
3. Use the date range picker modal to select start and end dates (e.g., `June 25, 2026` to `June 28, 2026`).
4. Confirm selection.
5. **Expected Output**:
   - SnackBar says `"Filing leave request..."` followed by `"Leave request filed successfully! Pending Admin approval."`.
   - A single row is inserted into the new `Leave_Request` table with `start_date`, `end_date`, `status` = `'Pending'`, and the current dentist's ID.
6. Navigate back to the **Workflow** tab.
7. Scroll down to the **My Leave Requests** list.
8. **Expected Output**:
   - The newly filed leave request is displayed showing the exact dates and a yellow **PENDING** status badge.
9. Click the **Cancel Request** button under the pending leave.
10. **Expected Output**:
    - SnackBar shows `"Cancelling leave request..."` and `"Leave cancelled."`.
    - The row is deleted from the `Leave_Request` table and disappears from the UI list.

---

## 5. Patient Treatment Records & Procedure Linkage (TC007 - History Table)

### Description
Dentists can record completed treatments for patients, selecting categories/procedures and writing custom clinical notes. The entry links directly to the procedure schema via UUID.

### Step-by-Step Execution
1. Go to the **Workflow** tab and click the **Treatment Entry** card.
2. Select a patient from the dropdown list or search bar (e.g., `Jane Patient`).
3. Choose a treatment **Category** (e.g., `General Checkups`).
4. Choose a specific **Procedure** (e.g., `Cleaning`).
5. Type custom notes/remarks into the clinical notes field (e.g., `"Patient has minor sensitivity on lower left molar. Advised regular flossing."`).
6. Click the **Save** button.
7. **Expected Output**:
   - SnackBar shows `"Saving treatment record..."` followed by `"Treatment record saved successfully!"`.
   - The dropdown selections and text fields are reset.
   - A new row is inserted into the `History` table.
   - **Verification**: In Supabase `History` table, check that the new row has:
     - `patient_id` = selected patient's ID.
     - `remarks` = clinical notes and categories.
     - `procedure_id` = the correct UUID lookup from the `Procedure` table.

---

## 6. Clinic Analytics & Fulfillment Monitoring (TC010)

### Description
Dentists can review their performance metrics, monthly income graphs, performed treatment categories, and appointment fulfillment rates.

### Step-by-Step Execution
1. Go to the **Workflow** tab.
2. Click **My Analytics** to open the analytics dashboard:
   - Review the bar/pie chart representing the most common treatment types.
   - Review the line graph showing monthly income trends.
3. Click **Fulfillment Rate** to open the fulfillment tracking page:
   - Check the percentage gauge representing fulfilled vs. missed/cancelled appointments.

---

## 7. Patient History Review

### Description
Dentists can search and browse the historical treatment history of all registered clinic patients.

### Step-by-Step Execution
1. Go to the **Workflow** tab (or the Home tab overview).
2. Click the **Total Patients** card.
3. **Expected Output**:
   - Pushes to the `DentistTotalPatientHistoryFocusWidget` page.
   - Displays a list of patients.
   - Clicking a patient displays their chronological treatment history list (newest first) including procedure dates, dentist names, and clinical remarks.
