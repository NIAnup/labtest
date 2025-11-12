# Test Request Flow

## Overview
The Blood Lab dashboard manages requests that flow between lab staff (“Add New Request”) and patients (“Client Form”). Every request is stored in Firebase Cloud Firestore using a normalized schema:

- `lab_requests`: one document per collection request
- `client_profiles`: reusable patient records
- `lab_details`: metadata about each lab location

UI surfaces:

- Dashboard buttons launch the lab-side (“Add New Request”) and patient-side (“Client Form”) flows.
- `Pending`, `Active`, `Completed`, and `Test Requests` screens are driven by the same `TestRequestProvider`, which reads and writes Firestore through `FirebaseRequestService`.

## Status Lifecycle
Requests move through these statuses (`RequestStatus` enum):

| Status      | Stored value  | Typical transition                                       |
|-------------|---------------|----------------------------------------------------------|
| Pending     | `pending`     | Newly created or client-submitted request                |
| Accepted    | `accepted`    | Lab acknowledges assignment                              |
| In Progress | `in_progress` | Sample collection or analysis underway                   |
| Completed   | `completed`   | Final report delivered to patient / Flavo                |
| Cancelled   | `cancelled`   | Request withdrawn by lab or patient                      |

Terminal states are `completed` and `cancelled`. All transitions update audit timestamps (`acceptedAt`, `inProgressAt`, `completedAt`, `cancelledAt`) via `FirebaseRequestService.updateStatus`.

## Collection Schemas

### `lab_requests` document
Created by the lab or when a patient submits a client form. Normalized pointers keep lab and patient data reusable.

```json
{
  "labId": "prime-diagnostics",
  "labDetailsId": "prime-diagnostics",
  "clientProfileId": "clients/8bj2x",
  "createdBy": "prime-diagnostics",
  "acceptedBy": "collector_42",
  "completedBy": "collector_42",
  "cancelledBy": null,
  "status": "pending",
  "urgency": "Urgent",
  "requestedTests": ["CBC", "Lipid Panel"],
  "notes": "Call before arrival",
  "location": {"latitude": 12.9804, "longitude": 77.6409},
  "formLinkId": "1699802645123123",
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "submittedAt": "<timestamp>",
  "acceptedAt": "<timestamp>",
  "inProgressAt": "<timestamp>",
  "completedAt": "<timestamp>",
  "cancelledAt": null,
  "expiresAt": "<timestamp>",
  "clientSnapshot": { /* embedded ClientProfile */ },
  "labSnapshot": { /* embedded LabDetails */ },
  "metadata": {
    "patientName": "Ananya Rao",
    "phoneNumber": "+91-90000-11111",
    "requestedTests": ["CBC", "Lipid Panel"],
    "notes": "Call before arrival",
    "coordinates": {
      "lat": 12.9804,
      "lng": 77.6409
    }
  }
}
```

Key points:

- `clientSnapshot` and `labSnapshot` embed immutable copies for quick rendering. Canonical records live in separate collections.
- `metadata` captures optional fields (emails, secondary address lines, coordinates) without bloating the primary model.
- `formLinkId` is the short code shared with patients. It remains unique per request and expires based on lab settings (`SettingsProvider.formExpiryHours`).

### `client_profiles` document
Created/updated when the lab pre-fills details or when a patient submits the client form.

```json
{
  "firstName": "Ananya",
  "lastName": "Rao",
  "phoneNumber": "+91-90000-11111",
  "email": "ananya.rao@example.com",
  "addressLine1": "12 Residency Road",
  "addressLine2": "MG Road Junction",
  "city": "Bengaluru",
  "state": "KA",
  "postalCode": "560025",
  "notes": "Allergic to latex",
  "location": {"latitude": 12.9721, "longitude": 77.5933},
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>"
}
```

### `lab_details` document
Synced from `SettingsProvider` when a lab user creates a request.

```json
{
  "id": "prime-diagnostics",
  "name": "Prime Diagnostics",
  "contactEmail": "support@primediagnostics.in",
  "contactPhone": "+91-80-5555-1234",
  "addressLine1": "44, 1st Main, Indiranagar",
  "addressLine2": "Bengaluru 560038",
  "latitude": 12.9847,
  "longitude": 77.6199,
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>"
}
```

## Screen Responsibilities

- `Add New Request` (dashboard button)
  - Uses `TestRequestProvider.createTestRequest`.
  - Saves lab metadata, optional preliminary patient info, and generates a `formLinkId`.
  - If the provider has contact details configured, these defaults populate the request metadata.

- `Client Form` (dashboard button or shared link)
  - Calls `TestRequestProvider.getRequestByFormLinkId` to hydrate the form.
  - On submission, invokes `submitClientForm`, storing client details, requests list, notes, and coordinates.
  - Maintains status `pending`. Lab staff can pick it up from the pending queue.

- `Test Requests` screen
  - Lists all `LabRequest` records with filters for status and search.
  - Popup menu supports `view`, `edit`, `accept`, `mark in progress`, `complete`, and `delete`.
  - Uses `TestRequestProvider.updateRequest` and `updateRequestStatus`.

- `Pending`, `Active`, `Completed` screens
  - Derived lists from the provider (`pendingRequests`, `activeRequests`, `completedRequests`).
  - Automatically refresh from Firestore on dashboard initialization.

## Status Handling Rules
- `Accept` → `accepted`: call `updateRequestStatus(requestId, 'accepted')`; sets `acceptedAt` and `acceptedBy`.
- `Start Collection` → `in_progress`: call `updateRequestStatus(requestId, 'in_progress')`; sets `inProgressAt`.
- `Complete` → `completed`: call `updateRequestStatus(requestId, 'completed')`; sets `completedAt` and `completedBy`.
- `Cancel` → `cancelled`: call `updateRequestStatus(requestId, 'cancelled')`; sets `cancelledAt` and `cancelledBy`.
- `Delete` removes the document entirely via `deleteRequest`. Use only if the patient no longer wants service.

All status transitions return the hydrated `LabRequest`, ensuring UI refreshes without extra fetches.

## Geolocation Usage
- When the lab captures latitude/longitude (either manually or via device location), the values persist under both `location` (GeoPoint) and `metadata.coordinates`.
- Flavo can query `lab_requests` filtered by `status == 'pending'` and `location` near the patient to show only relevant pickup jobs.
- If coordinates are missing, the system still stores textual addresses for manual routing.

## Integration Steps for Flavo
1. Fetch pending requests:
   ```js
   db.collection('lab_requests')
     .where('status', '==', 'pending')
     .where('labId', '==', '<lab-slug>')
     .get()
   ```
   Optional: apply a GeoQuery on `location` to keep results near the courier.
2. Display request summary using:
   - `metadata.patientName` or `clientSnapshot.fullName`
   - `requestedTests`
   - `urgency`
   - `labSnapshot` contact/address for pickup.
3. When a courier accepts in the Flavo app, call a secure backend endpoint that invokes `updateStatus` to move the record to `accepted` or `in_progress`.
4. On completion, update to `completed` and attach proof-of-delivery metadata if required (extend the `metadata` map).

## Prompt for Flavo App Team
Copy/paste into your knowledge base or onboarding docs:

```
You are integrating the Blood Lab “Test Request” flow. Each request lives in Firestore (`lab_requests`) with normalized `client_profiles` and `lab_details`. Respect the status lifecycle: pending → accepted → in_progress → completed (or cancelled). Only show pending jobs that match the courier's current region (GeoPoint `location` or metadata `coordinates`). When a courier accepts, call our secure endpoint that wraps `FirebaseRequestService.updateStatus`. Ensure client contact, lab pickup address, and requested tests are surfaced. If you need a new field, add it to the `metadata` map so the lab UI and Flavo stay in sync.
```


