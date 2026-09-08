# Toothy Clinic App - Functional & Non-Functional Requirements (FR & NFR)

This document outlines the detailed Functional Requirements (FR) and Non-Functional Requirements (NFR) for the **Toothy Clinic App**, structured around the sprint roadmap and system architecture defined in [AGENTS.md](file:///c:/BiboyStuffs/Flutterflow/toothy_c_o/.agents/AGENTS.md) and the database schema.

---

## 1. Functional Requirements (FR)

Functional requirements define what the system must do—the core features, actions, and user flows.

### FR1: Authentication & Role Management
* **FR1.1: Registration & Login**: The system must allow users to register and log in using an email address and a secure password.
* **FR1.2: Session Persistence**: The application must persist the login session securely on the mobile device so users do not have to log in repeatedly.
* **FR1.3: Role-Specific Routing**: Upon successful authentication, the system must route users to their appropriate, role-based dashboard:
  * **Patient Dashboard**: Offers appointment booking, history viewing, chatbot access, and service pricing.
  * **Dentist Dashboard**: Offers schedule configuration, leave request submissions, treatment history tracking, and patient search.
  * **Admin Dashboard**: Offers user role management, patient profile controls, leave review panels, and clinic analytics.
* **FR1.4: Admin Role Assignment**: Admins must be able to view all registered users and modify their roles (e.g., promote a user to Dentist or Admin).
* **FR1.5: Dentist Color-Coding**: The user interface must color-code dentists dynamically based on their specialization type (e.g., General Dentist vs. Orthodontist) to guide patients during selection.

### FR2: Patient Profile & Record Management
* **FR2.1: Admin Patient Profile CRUD**: Admins must be able to create, read, update, and deactivate patient profiles.
* **FR2.2: Profile Fields Validation**: The system must enforce mandatory data fields for patient profiles, including:
  * Full Name
  * Contact Info (Phone, Email)
  * Mailing Address
  * Medical Fields (Allergies, Medical Conditions, Blood Type, Emergency Contact Info)
* **FR2.3: Cloud Synchronization**: All profile modifications must synchronize instantly to Supabase for multi-device availability.
* **FR2.4: Real-time Search**: The search function must allow admins and dentists to query patient profiles dynamically by name or phone number.

### FR3: Dentist Scheduling & Leave Management
* **FR3.1: Recurring Schedule Configuration**: Dentists must be able to configure their weekly default schedule (recurring workdays and start/end time blocks) through the application.
* **FR3.2: Leave Request Submission**: Dentists must be able to submit vacation/leave requests with specified start/end dates and justifications.
* **FR3.3: Admin Leave Review**: Admins must be able to view, approve, or reject pending dentist leave requests.
* **FR3.4: Live Booking Integration**: Once a leave request is approved, the system must block out those dates from the patient booking page and flag any conflicting appointments.

### FR4: Cost Transparency & Service Catalog
* **FR4.1: Service Catalog Display**: The app must display a categorized list of all active dental procedures (e.g. Preventive, Restorative, Orthodontic).
* **FR4.2: Real-time Pricing**: Each catalog item must display its standard cost, fetched live from the database.
* **FR4.3: Read-Only Constraint for Patients**: Pricing fields must be strictly read-only for patient accounts. Only authorized Admins and Dentists can update treatment costs.

### FR5: Appointment Booking
* **FR5.1: Patient Booking Interface**: Patients must be able to schedule appointments by selecting a dentist, an active procedure, and an available date and time slot.
* **FR5.2: Double-Booking Prevention**: The database backend must prevent duplicate bookings for the same dentist at the same date and time.
* **FR5.3: Booking Notifications**: The system must generate push notifications and in-app notifications to confirm bookings, provide reminders, or alert users to status updates (e.g., Confirmed, Rescheduled, Cancelled).

### FR6: Treatment History Tracking
* **FR6.1: Treatment Logs**: Dentists must be able to document completed procedures, add clinical remarks, and link entries directly to a patient's profile.
* **FR6.2: Historical Audit Trail**: Patients and dentists must be able to view a chronological log of all completed treatments, sorted by date (most recent first).

### FR7: AI-Powered Appointment Prediction & Slots
* **FR7.1: Optimal Slot Suggestions**: The system must suggest 3 optimal appointment slots based on historic clinic traffic, provider availability, and patient preference (Morning vs. Afternoon).
* **FR7.2: Conflict Avoidance**: Suggested slots must not overlap with existing bookings or approved dentist leaves.

### FR8: AI Chatbot Assistant
* **FR8.1: Frequently Asked Questions (FAQ)**: Patients must be able to interact with an AI assistant to get answers on clinic hours, locations, services, and recommendations.
* **FR8.2: Fallback Protocols**: If the AI cannot resolve a question, it must provide a structured fallback message with clinic contact numbers.

### FR9: Clinic Analytics Dashboard
* **FR9.1: Treatment Metrics**: Dentists and admins must be able to view charts displaying the "most common treatments" performed.
* **FR9.2: Revenue Trends**: The system must render a line graph showing monthly income trends based on recorded payments.
* **FR9.3: Fulfillment Rate**: The system must calculate the clinic's "appointment fulfillment rate" (ratio of Completed vs. Booked appointments).
* **FR9.4: Peak Traffic Heatmap**: The app must highlight the busiest appointment days and hours on a heatmap or bar chart.

---

## 2. Non-Functional Requirements (NFR)

Non-Functional Requirements describe the quality attributes, system characteristics, and operational constraints of the application.

### NFR1: Performance & Response Times
* **NFR1.1: Query Latency**: Database searches (such as the patient profile search) must return results within **2 seconds** under normal network conditions.
* **NFR1.2: Real-time Cloud Sync**: Local mobile app data changes must write to the cloud database within **1.5 seconds**.
* **NFR1.3: Frame Rate**: The mobile application must render transitions and animations smoothly at a target of **60 frames per second (fps)** on modern iOS and Android devices.

### NFR2: Security & Privacy
* **NFR2.1: Data Encryption in Transit**: All communications between the mobile application and the Supabase backend must be encrypted using HTTPS/TLS (TLS 1.2 or higher).
* **NFR2.2: Password Encryption**: Passwords must be hashed and encrypted at the cloud backend level using secure hashing algorithms (e.g., bcrypt/scrypt via Supabase Auth).
* **NFR2.3: Data Access Control (Row-Level Security)**: Row-Level Security (RLS) must be enabled on Supabase. Patients must only be able to view their own records (appointments, payments, notifications, and history), whereas dentists and admins have broader access.
* **NFR2.4: Session Integrity**: Access tokens stored on the device must be isolated in secure device storage (e.g., iOS Keychain, Android Keystore).

### NFR3: Reliability & Availability
* **NFR3.1: Notification Delivery**: The push notification engine must deliver booking confirmations with a reliability rate of **99%** or higher.
* **NFR3.2: Conflict Recovery**: The transaction layer must handle concurrent booking attempts gracefully without corrupting database integrity.
* **NFR3.3: System Availability**: The cloud database and API endpoints (Supabase) should maintain an uptime of **99.9%**.

### NFR4: Usability & User Experience (UX)
* **NFR4.1: Clean Navigation**: Critical user operations (booking a slot, checking history, viewing payments) must be accessible within **3 taps** from the home dashboard.
* **NFR4.2: Visual Aids**: Specialized dentists must have distinct color-coded styling in scheduling and dashboard lists to avoid scheduling confusion.
* **NFR4.3: Accessibility**: The user interface must support standard dynamic text sizing and maintain high-contrast ratios (WCAG 2.1 AA standard) for readability.

### NFR5: Portability & Cross-Platform Compatibility
* **NFR5.1: Device Compatibility**: The application must run on both Android and iOS platforms.
* **NFR5.2: Target OS Versions**:
  * **iOS**: Compatible with iOS 14.0 and above.
  * **Android**: Compatible with Android API Level 26 (Android 8.0 Oreo) and above.
* **NFR5.3: Form Factor Responsiveness**: The layouts must adapt to both standard mobile screens and tablets.

### NFR6: Maintainability
* **NFR6.1: Code Standards**: The codebase must adhere to the official Flutter style guidelines and linting rules defined in `analysis_options.yaml`.
* **NFR6.2: Component Reusability**: Common elements (e.g., custom navbars, loading widgets, transaction cards) must be implemented as modular widgets.
