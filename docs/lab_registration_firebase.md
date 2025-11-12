# Lab Registration ↔ Firebase Integration

This document explains how the lab registration flow talks to Firebase, how the
data is structured in Firestore, and what happens during submission. It is
intended for developers who need to understand, debug, or extend the flow.

---

## High-Level Flow

1. **User completes the 4-step registration wizard** (`lib/screen/Auth/registration/lab_registration_form.dart`).
2. On the final step the user presses **Submit Registration**.
3. `LabRegistrationProvider.submitRegistration` (`lib/provider/lab_registration_provider.dart`) runs:
   - Validates that every section of the wizard was filled in.
   - Creates a Firebase Auth user with the supplied email/password.
   - Builds a `LabRegistration` model (`lib/models/lab_registration_model.dart`).
   - Writes the record to Firestore inside the `lab_registrations` collection.
   - Triggers an email verification and navigates to the verification screen.

Any failure along the way is surfaced to the UI via a snackbar and logged with
`KDebugPrint`.

---

## Firestore Collection Design

- **Collection name:** `lab_registrations` (see `LabRegistration.collectionName`)
- **Document ID:** The Firebase Auth user ID (`uid`) created for the lab.  
  If account creation fails, no Firestore write happens.

### Document Shape

Below is the JSON structure that ends up in Firestore. Timestamps are stored as
`Timestamp` objects; the example uses ISO strings for readability.

```json
{
  "id": "aBc123Uid",
  "authUid": "aBc123Uid",
  "labName": "Acme Diagnostics",
  "ownerName": "Dr. Jane Smith",
  "contactNumber": "+1 555-010-2030",
  "email": "owner@acmediagnostics.com",
  "labAddress": "42 Wellness Avenue",
  "cityStatePincode": "Springfield, IL 62704",
  "identityProofType": "Aadhar Card",
  "businessType": "Pvt. Ltd.",
  "gstNumber": "22AAAAA0000A1Z5",
  "panNumber": "AAAAA0000A",
  "isGstRegistered": "Yes",
  "licenseNumber": "LIC-123456",
  "licenseExpiryDate": "2025-12-31T00:00:00.000Z",
  "issuedBy": "Health Authority",
  "status": "under_review",
  "reviewNotes": null,
  "emailVerified": false,
  "createdAt": "2025-11-09T12:00:00.000Z",
  "updatedAt": "2025-11-09T12:00:00.000Z",
  "documents": [
    {
      "type": "identity_proof",
      "label": "Aadhar Card",
      "originalFileName": "aadhar.pdf",
      "storagePath": null,
      "uploaded": false,
      "uploadedAt": null
    },
    {
      "type": "business_registration",
      "label": "Business Registration Certificate",
      "originalFileName": "registration.pdf",
      "storagePath": null,
      "uploaded": false,
      "uploadedAt": null
    }
  ]
}
```

> **Note:** File uploads are not yet pushed to Firebase Storage. The document
> list captures filenames so that a subsequent background process can perform
> uploads and update `storagePath` / `uploaded` fields.

---

## Provider Responsibilities

`LabRegistrationProvider` now encapsulates all Firebase interactions:

- Holds form controllers, dropdown choices, file handles, and validation logic.
- Maintains `isSubmitting` to prevent duplicate submissions and to toggle the
  loading state on the submit button.
- Converts UI state into a `LabRegistration` data object before saving.
- Maps common `FirebaseAuthException` codes to user-friendly messages.
- Attempts to roll back the Firebase Auth user if Firestore write fails.

Relevant helper methods:

- `_validateAllSteps()` – gatekeeper for the four wizard steps.
- `_buildDocuments()` – converts selected files to a serialisable list.
- `_mapAuthErrorToMessage()` – human-readable error strings for snackbars.

For quick demos there is also a mock account (`mock.lab@gmail.com` /
`MockPass@123`). When those exact credentials are entered the provider bypasses
Firebase, drops the user directly into the dashboard, and shows a banner
indicating that demo mode is active.

---

## Login Flow

The standard login screen (`lib/screen/Auth/login/loginform.dart`) is backed by
`LoginProvider` (`lib/provider/login_provider.dart`). When the user submits the
form:

1. The form validates email and password locally.
2. `FirebaseAuth.signInWithEmailAndPassword` authenticates the user.
3. The provider looks up the registration document in Firestore using the
   authenticated user's UID.
4. Based on the stored status (`approved`, `under_review`, `rejected`) and
   whether the email has been verified, the user is routed to:
   - `RouteNames.dashboard` when `status == approved` **and** email verified.
   - `RouteNames.verificationPending` in all other cases, with contextual
     snackbar guidance (rejection or still under review).
5. If the email is not verified the provider attempts to resend a verification
   link and notifies the user.

For quick demos there is also a mock account (`mock.lab@gmail.com` /
`MockPass@123`). When those exact credentials are entered the provider bypasses
Firebase, drops the user directly into the dashboard, and shows a banner
indicating that demo mode is active.

Error handling mirrors `submitRegistration`, mapping common
`FirebaseAuthException` codes to friendly messages and logging via
`KDebugPrint`. Network and unexpected errors fall back to a generic snackbar.

---

## Extending the Workflow

| Goal | Suggested Changes |
| --- | --- |
| **Persist uploaded files** | Add `firebase_storage` to `pubspec.yaml`. Extend `_buildDocuments()` to upload to Storage and populate `storagePath` / `uploaded`. |
| **Admin approval workflow** | Add server-side rules / Cloud Functions that update `status`, `reviewNotes`, and send notifications. |
| **Audit trail** | Create a sub-collection (e.g., `lab_registrations/{id}/events`) and append events from UI or backend. |
| **Analytics** | Stream Firestore changes into a dashboard or BigQuery via Cloud Functions. |

---

## Local Setup Checklist

1. Firebase project configured with Authentication (Email/Password) enabled.
2. Firestore security rules permitting the write (currently handled client-side).
3. `google-services.json` / `GoogleService-Info.plist` already present in the repo.
4. For Flutter web, ensure Firebase Hosting or emulator config matches the project.

Run the app with:

```
flutter run
```

and follow the wizard. On successful submission, check Firestore →
`lab_registrations` for the new document.

---

## Troubleshooting Tips

- **Email already in use**: The snackbar reports it immediately. Delete any
  stale users from Firebase Auth if needed.
- **Firestore permission errors**: Validate Firestore rules; during development
  the emulator is recommended.
- **No document appears**: Ensure form validation passed; check logs emitted via
  `KDebugPrint`.
- **Need to resume submission**: Because files are not uploaded yet, the current
  implementation assumes a single-session submission. If you need resume
  support, persist draft data locally and guard against duplicate Auth accounts.

---

For further enhancements or backend automation, start from this document and
the referenced code files. Contributions should keep the contract defined here
backwards compatible, or document breaking changes explicitly.

