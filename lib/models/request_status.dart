/// Enumerates the lifecycle states a lab request can move through.
enum RequestStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled,
}

extension RequestStatusValue on RequestStatus {
  /// Storage value used in Firestore and shared APIs.
  String get value {
    switch (this) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.inProgress:
        return 'in_progress';
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.cancelled:
        return 'cancelled';
    }
  }

  /// User-facing label for UI presentation.
  String get displayName {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.inProgress:
        return 'In Progress';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isTerminal =>
      this == RequestStatus.completed || this == RequestStatus.cancelled;

  static RequestStatus fromValue(String? raw) {
    if (raw == null || raw.isEmpty) {
      return RequestStatus.pending;
    }

    switch (raw) {
      case 'accepted':
        return RequestStatus.accepted;
      case 'in_progress':
      case 'inProgress':
        return RequestStatus.inProgress;
      case 'completed':
        return RequestStatus.completed;
      case 'cancelled':
      case 'canceled':
        return RequestStatus.cancelled;
      case 'pending':
      default:
        return RequestStatus.pending;
    }
  }
}

extension RequestStatusParsing on String {
  RequestStatus toRequestStatus() => RequestStatusValue.fromValue(this);
}

