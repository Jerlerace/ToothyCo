# Toothy Clinic App - Agent Guidelines & Backlog

This file serves as the workspace-level configuration and reference for all AI coding agents working on the **Toothy Clinic App**. It contains the project requirements, the product backlog, and guidelines to ensure implementation is aligned with expectations.

---

## Project Requirements & Backlog

### Sprint 1: Authentication & Role Management
- **TC001: Mobile Registration & Login** (Status: **TO BE VALIDATED / QA**)
  - *User Story*: As a mobile user, I want to securely register and log in so that my data syncs to the cloud.
  - *Acceptance Criteria*:
    1. App validates email and password formatting.
    2. Passwords are encrypted in the cloud database.
    3. Session securely persists on the mobile device.
    4. Users are routed to role-specific mobile dashboards.
- **TC002: Role Assignment** (Status: **TO BE VALIDATED / QA**)
  - *User Story*: As an admin, I want to assign roles (patient, dentist, admin) via the app so that access levels are controlled.
  - *Acceptance Criteria*:
    1. Admin can view a cloud-synced list of all registered users.
    2. Admin can select a user and update their role via mobile UI.
    3. Cloud backend immediately applies the new permission limits upon saving.
    4. Different dentist types are distinguished with dynamic color coding.

### Sprint 2: Patient & Dentist Availability
- **TC003: Cloud Patient Records** (Status: **Pending**)
  - *User Story*: As an admin, I want to manage patient profiles on my device so that records are updated in real-time.
  - *Acceptance Criteria*:
    1. Admin can Add, Edit, or Deactivate patient profiles.
    2. Data immediately syncs to the cloud for cross-device access.
    3. System validates required fields (Name, Contact, Address).
    4. Profile search function returns cloud results within 2 seconds.
- **TC004: Dentist Scheduling** (Status: **ONGOING**)
  - *User Story*: As a dentist, I want to set my availability on my mobile device so patients know when I am present.
  - *Acceptance Criteria*:
    1. Dentist can select working days and specific time blocks via the app.
    2. Dentist can file submission request to block out dates for leaves/vacations.
    3. Schedule changes sync to the cloud instantly and reflect on the booking page upon admin approval.

### Sprint 3: Cost & Booking
- **TC005: Cost Transparency** (Status: **TO BE VALIDATED / QA**)
  - *User Story*: As a patient, I want to view estimated procedure costs in the app so that I can prepare my budget.
  - *Acceptance Criteria*:
    1. App displays a categorized list of dental services.
    2. Each service shows an estimated price fetched from the cloud.
    3. Prices are strictly read-only for patients (Admin/Dentist editable).
- **TC006: Mobile Patient Booking** (Status: **Pending**)
  - *User Story*: As a patient, I want to book an appointment through the app so that I get a push notification reminder.
  - *Acceptance Criteria*:
    1. Patient can select an available date, time, and specific dentist.
    2. Cloud backend prevents double-booking in real-time.
    3. Patient receives a booking confirmation push notification upon successful save.

### Sprint 4: Mid-Project Review
- **TC-R1: Mid-Project Review & Testing** (Status: **Pending**)
  - *User Story*: As a development team, we want to review previously completed modules so that system functionality is validated.
  - *Acceptance Criteria*:
    1. All previously implemented mobile modules function without critical errors.
    2. Identified bugs are resolved.
    3. Push notifications fire reliably.
    4. System documentation is updated.

### Sprint 5: Treatment History
- **TC007: Treatment History Tracking** (Status: **Pending**)
  - *User Story*: As a dentist, I want to track patient treatments on my tablet/phone so that I can review their dental history.
  - *Acceptance Criteria*:
    1. Dentist can input procedure details and notes via mobile.
    2. Treatment records sync to the cloud and are linked to the patient profile.
    3. History can be sorted by date (most recent first) and accessible on any authorized device.

### Sprint 6: AI Appointment Prediction
- **TC008: AI Appointment Prediction** (Status: **Pending**)
  - *User Story*: As a patient, I want the app to suggest available time slots so that I can quickly find the best time to visit.
  - *Acceptance Criteria*:
    1. AI algorithm suggests 3 optimal time slots based on past clinic traffic and dentist availability.
    2. Suggested slots automatically avoid overlapping with existing cloud bookings.
    3. Suggestions prioritize the requested preferred time (Morning/Afternoon).

### Sprint 7: Assistant & Analytics
- **TC009: AI Chatbot** (Status: **Pending**)
  - *User Story*: As a patient, I want to chat with an AI assistant in the app so that I can get immediate answers 24/7.
  - *Acceptance Criteria*:
    1. Chatbot is accessible via an action button on the mobile screen.
    2. AI correctly answers FAQs regarding clinic hours, location, services, and suggestions with a limit that it is only used for informational purposes.
    3. Fallback message provided if the AI cannot answer the question.
- **TC010: Mobile Analytics Dashboard** (Status: **Pending**)
  - *User Story*: As a dentist/admin, I want to view clinic analytics on my phone so that I can make data-driven decisions.
  - *Acceptance Criteria*:
    1. App displays a chart of the 'Most common treatments' performed.
    2. App displays 'Monthly income trends' via a line graph.
    3. App calculates and displays the 'Appointment Fulfillment Rate'.
    4. App highlights 'Peak appointment times' on a heatmap/bar chart.

### Sprint 8: Finalization
- **TC-R2: Final Integration & Deployment** (Status: **Pending**)
  - *User Story*: As an individual developer, I want to finalize and test the complete system so that the application is ready for deployment.
  - *Acceptance Criteria*:
    1. All mobile app modules function correctly together.
    2. App performance and cloud sync is stable.
    3. App usability tested on Android/iOS emulators.
    4. Documentation and final deliverables (APK) are completed.

---

## Agent Instructions & Rules

1. **Verify Before Coding**: Before starting on a module, verify its dependencies.
2. **Follow Flutter/Dart Best Practices**: Keep code clean, type-safe, and well-structured.
3. **Real-time Sync**: When implementing features that modify data, ensure they immediately sync/update to/from the cloud backend (e.g. Firebase or equivalent).
4. **Push Notifications**: Pay special attention to notifications for bookings and reminders, ensuring they function reliably.
