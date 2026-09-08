# Toothy Clinic App v2.0 - Patient Functionality Step-by-Step Walkthrough

This document provides step-by-step instructions to verify every major functionality implemented for the **Patient** role in the v2.0 release of the Toothy Clinic App, including the latest Tab 0 Home Dashboard and Navigation layout adjustments.

---

## 🔑 Patient Test Credentials

Use the following credentials to sign in and test the Patient features:

| Email | Password | Primary Workflow Page |
| :--- | :--- | :--- |
| `patient_1@gmail.com` | `patient_1password` | My Care Hub (Home, Costs, Bookings) |
| `patient_2@gmail.com` | `patient_2password` | My Care Hub (Home, Costs, Bookings) |

---

## 📋 Patient Step-by-Step Test Scenarios

### Scenario 1: New Patient Registration (TC001)
- **Objective**: Test new user signup validation, password matching, and automatic profile creation.
- **Steps**:
  1. Launch the application. If logged in, sign out via the Profile tab.
  2. From the Splash landing screen, tap **Sign Up**.
  3. Enter a Full Name (e.g., `Alice Johnson`), pick a Date of Birth, and enter a unique email (e.g., `alice@gmail.com`).
  4. In the **Password** field, type `alicepassword`.
  5. In the **Confirm Password** field, type a mismatching password (e.g., `mismatch`).
  6. Tap the **Create Account** button.
     - *Expected Outcome*: An on-screen warning stating `"Passwords don't match!"` will prevent form submission.
  7. Correct the **Confirm Password** field to match exactly (`alicepassword`). Tap **Create Account**.
     - *Expected Outcome*: The user is signed up successfully, logged in, and redirected to the **Unified Homepage**.
     - *Database Verification*: In Supabase, check the `Patient` table; a matching row with `patient_id` = your new user UID is automatically initialized.

### Scenario 2: Bottom Navigation Bar & Home Dashboard (Tab 0)
- **Objective**: Verify that the new Home tab layout loads details dynamically and is styled appropriately.
- **Steps**:
  1. Tap the bottom navigation bar icons.
  2. Select **Tab 0 (Home Icon)**.
     - *Expected Outcome*: 
       - **Hero Banner**: A gradient blue-to-purple header displays the dynamic greeting: `"Welcome Back, Alice Johnson"` (or the logged-in user's name).
       - **Clinic Overview**: A card displaying the clinic's operating hours (*Monday - Saturday: 8:00 AM - 5:00 PM*), physical address, and contact numbers.
       - **Our Services**: A grid of service category cards (Preventive, Cosmetic, Restoration, Surgery).
       - **Dental Health Tips**: Interactive quick advice cards.
       - **AI Help Promo**: Shortcut banner details for the chatbot.
  3. Tap **Tab 1 (Workflow Icon)** to enter **My Care Hub** (the Patient's dashboard containing active appointments, procedure lists, and booking actions).
  4. Tap **Tab 2 (Bell Icon)** to view notifications.
  5. Tap **Tab 3 (Person Icon)** to manage your profile and records.

### Scenario 3: Tab Info Modals
- **Objective**: Ensure that info buttons provide helpful descriptions for each tab navigation state.
- **Steps**:
  1. On any of the bottom tabs (Home, Workflow, Notifications, Profile), tap the **Info Icon** (`info_outline_rounded`) in the top-right corner of the AppBar.
  2. **Expected Outcome**: An AlertDialog box titled `"About this Tab"` slides in, displaying specific descriptions for the active screen (e.g. on Tab 0 it details the Overview hours, on Tab 1 it describes workflow tasks, etc.).
  3. Click **Close** to return.

### Scenario 4: View & Update Medical Records (TC003)
- **Objective**: Manage clinical details and emergency contacts.
- **Steps**:
  1. Go to the **Profile Tab (Tab 3)**.
  2. Tap the **"View Records"** card container located below the profile description.
  3. **Expected Outcome**: The screen switches to the **Medical Profile & Records** sub-view. For newly created accounts, the fields display "Not specified" or "None specified".
  4. Tap **Edit Details**.
     - *Expected Outcome*: The fields turn into editable text input fields.
  5. Fill in the following mock details:
     - *Blood Type*: `A-`
     - *Allergies*: `Aspirin, Ibuprofen`
     - *Medical Conditions*: `None`
     - *Emergency Contact Name*: `Robert Johnson`
     - *Emergency Contact Phone*: `0917-555-4321`
  6. Tap **Save**.
     - *Expected Outcome*: The inputs revert to read-only text. A SnackBar confirmation message appears stating: `"Medical records updated successfully!"`.
     - *Database Verification*: In the `Patient` table in Supabase, verify the fields for your UID match these inputs in real-time.
  7. Tap **Back to Profile** (top left arrow) to return to the main Profile page.

### Scenario 5: Procedure Cost Transparency (TC005) & Info Dialogs
- **Objective**: View clinic service rates.
- **Steps**:
  1. Go to the **Workflow Tab (Tab 1)** -> Tap the **Procedures & Pricing** card.
  2. **Expected Outcome**: A lists of active clinic services is queried from the database showing estimated costs.
  3. Verify the subtitle dynamically updates showing the count of loaded active services (e.g., `"4 Services"`).
  4. Tap the **Info Icon** in the top right.
     - *Expected Outcome*: An AlertDialog titled `"Dental Services & Pricing"` explains how patients should use these price ranges for budget preparations. Tap **Close**.
  5. Verify that the price listings are strictly read-only and no editing options are visible to the Patient.

### Scenario 6: Booking Appointments (TC006) & AI Suggestion (TC008)
- **Objective**: Book an appointment, retrieve AI quiet-traffic suggestions, and test double-booking prevention.
- **Steps**:
  1. Go to the **Workflow Tab (Tab 1)** -> Tap **Book Appointment**.
  2. Select a Procedure (e.g. *Teeth Cleaning*) from the dropdown.
     - *Expected Outcome*: A green info card dynamically appears displaying the estimated cost (e.g., `₱1,500`).
  3. Select a Dentist (e.g., *Dr. Sarah Mitchell*).
  4. Tap **Choose Appointment Date** and select a date in the calendar modal.
  5. Under **AI Suggested Optimal Slots**, select your preference: **Morning** or **Afternoon**.
     - *Expected Outcome*: The system analyzes booking traffic on the selected date and renders up to 3 quietest time slots. Click on one of the suggested chips.
  6. Under **Available Time Slots**, click to choose a matching time chip.
  7. Enter comments in the **Notes / Concerns** field (e.g., `"Regular checkup"`).
  8. Click **Schedule Appointment**.
     - *Expected Outcome*: The booking is saved. A simulated push notification banner slides down from the top confirming: `🔔 Booking Confirmed! Your appointment with Dr. Sarah Mitchell on [Date] at [Time] is scheduled.`
  9. Go back to the **Workflow Tab** -> **My Appointments** to verify the booking appears in the list.
  10. **Double-Booking Check**: Tap **Book Appointment again**, select the same dentist, date, and exact time slot, and tap **Schedule Appointment**.
      - *Expected Outcome*: A warning SnackBar notifies you that the slot is already booked, blocking the double-booking.

### Scenario 7: Notifications & Mark Read
- **Objective**: Review inbox notifications and toggle read states.
- **Steps**:
  1. Go to the **Notifications Tab (Tab 2)**.
  2. Locate any unread alert (distinguished by a blue border and soft highlight).
  3. Tap the alert card.
     - *Expected Outcome*: The highlight and blue border clear.
     - *Database Verification*: The notification row's `is_read` flag is updated to `true` in Supabase.

### Scenario 8: AI Chatbot Assistant (TC009)
- **Objective**: Interact with the FAQ bot.
- **Steps**:
  1. Tap the **floating action button** (chat icon) on the bottom-right corner of the Home/Workflow dashboard.
  2. Ask: `"what are your prices?"` or `"how much is whitening?"`.
     - *Expected Outcome*: The chatbot replies with procedure names and dynamic pricing list from the database.
  3. Ask: `"who are the doctors?"`.
     - *Expected Outcome*: The chatbot lists the dentists.
  4. Ask: `"can I get a discount?"` (out of scope).
     - *Expected Outcome*: The chatbot outputs the fallback message directing you to call the clinic desk at `(02) 888-DENT`.

---

## 📋 Dentist Step-by-Step Test Scenarios (Update)

### Leave Cancellation Confirmation
- **Objective**: Test that cancel actions request verification before deletion.
- **Steps**:
  1. Log in as `dentist_1@gmail.com` / `dentist_1password`.
  2. Go to the **Workflow Tab (Tab 1)** -> **My Schedule** -> file a leave request.
  3. Go back to **Workflow Tab** -> **My Leave Requests**.
  4. On the pending request card, tap **Cancel Request**.
     - *Expected Outcome*: A bottom confirmation sheet slides up stating: `"Are you sure you want to cancel this leave request? This action cannot be undone."`
  5. Tap **Cancel** to abort, or tap **Confirm Delete** to delete the request.
