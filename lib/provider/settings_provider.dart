import 'package:flutter/material.dart';

/// Stores lab-level preferences that drive how the Blood Lab
/// experience behaves across the app. Values are kept locally
/// for now but the API allows wiring them to a backend later.
class SettingsProvider extends ChangeNotifier {
  // Lab profile
  String _labName = 'Acme Diagnostics';
  String _contactEmail = 'support@acmediagnostics.com';
  String _contactPhone = '+1 (555) 010-2030';
  String _ownerName = 'Dr. Sarah Lane';
  String _labAddress = '42 Wellness Avenue, Springfield';
  String _cityStatePincode = 'Springfield, IL 62704';
  String _operatingHours = 'Mon-Sat • 8:00 AM - 8:00 PM';

  // Notification preferences
  bool _notifyOnNewRequest = true;
  bool _notifyOnPendingAging = true;
  bool _dailySummaryEmail = false;
  bool _notifyByEmail = true;
  bool _notifyBySms = false;
  bool _notifyByWhatsApp = true;

  // Workflow defaults
  String _defaultUrgency = 'Normal';
  int _formExpiryHours = 1;
  bool _autoAssignCollector = false;
  bool _autoDeleteExpiredForms = true;

  // Security preferences
  bool _enableTwoFactor = false;
  int _sessionTimeoutMinutes = 30;

  // Terms & feedback
  bool _acceptTerms = true;
  DateTime? _termsAcceptedAt = DateTime.now();
  String? _lastFeedback;

  // Support + sharing
  final String _supportPhone = '+1 (555) 010-2030';
  final String _supportEmail = 'help@acmediagnostics.com';
  final String _supportWhatsApp = '+1 (555) 010-2090';
  final String _inviteLink = 'https://bloodlab.app/invite';

  // Getters
  String get labName => _labName;
  String get contactEmail => _contactEmail;
  String get contactPhone => _contactPhone;
  String get ownerName => _ownerName;
  String get labAddress => _labAddress;
  String get cityStatePincode => _cityStatePincode;
  String get operatingHours => _operatingHours;

  bool get notifyOnNewRequest => _notifyOnNewRequest;
  bool get notifyOnPendingAging => _notifyOnPendingAging;
  bool get dailySummaryEmail => _dailySummaryEmail;
  bool get notifyByEmail => _notifyByEmail;
  bool get notifyBySms => _notifyBySms;
  bool get notifyByWhatsApp => _notifyByWhatsApp;

  String get defaultUrgency => _defaultUrgency;
  List<String> get urgencyOptions => const ['Normal', 'Urgent'];

  int get formExpiryHours => _formExpiryHours;
  List<int> get formExpiryOptions => const [1, 4, 8, 12, 24];

  bool get autoAssignCollector => _autoAssignCollector;
  bool get autoDeleteExpiredForms => _autoDeleteExpiredForms;

  bool get enableTwoFactor => _enableTwoFactor;
  int get sessionTimeoutMinutes => _sessionTimeoutMinutes;
  List<int> get sessionTimeoutOptions => const [15, 30, 60, 120];

  bool get acceptTerms => _acceptTerms;
  DateTime? get termsAcceptedAt => _termsAcceptedAt;
  String? get lastFeedback => _lastFeedback;
  String get supportPhone => _supportPhone;
  String get supportEmail => _supportEmail;
  String get supportWhatsApp => _supportWhatsApp;
  String get inviteLink => _inviteLink;

  // Setters
  void updateLabName(String value) {
    if (value == _labName) return;
    _labName = value.trim();
    notifyListeners();
  }

  void updateContactEmail(String value) {
    if (value == _contactEmail) return;
    _contactEmail = value.trim();
    notifyListeners();
  }

  void updateContactPhone(String value) {
    if (value == _contactPhone) return;
    _contactPhone = value.trim();
    notifyListeners();
  }

  void updateOwnerName(String value) {
    if (value == _ownerName) return;
    _ownerName = value.trim();
    notifyListeners();
  }

  void updateLabAddress(String value) {
    if (value == _labAddress) return;
    _labAddress = value.trim();
    notifyListeners();
  }

  void updateCityStatePincode(String value) {
    if (value == _cityStatePincode) return;
    _cityStatePincode = value.trim();
    notifyListeners();
  }

  void updateOperatingHours(String value) {
    if (value == _operatingHours) return;
    _operatingHours = value.trim();
    notifyListeners();
  }

  void toggleNotifyOnNewRequest(bool value) {
    if (value == _notifyOnNewRequest) return;
    _notifyOnNewRequest = value;
    notifyListeners();
  }

  void toggleNotifyOnPendingAging(bool value) {
    if (value == _notifyOnPendingAging) return;
    _notifyOnPendingAging = value;
    notifyListeners();
  }

  void toggleDailySummaryEmail(bool value) {
    if (value == _dailySummaryEmail) return;
    _dailySummaryEmail = value;
    notifyListeners();
  }

  void toggleNotifyByEmail(bool value) {
    if (value == _notifyByEmail) return;
    _notifyByEmail = value;
    notifyListeners();
  }

  void toggleNotifyBySms(bool value) {
    if (value == _notifyBySms) return;
    _notifyBySms = value;
    notifyListeners();
  }

  void toggleNotifyByWhatsApp(bool value) {
    if (value == _notifyByWhatsApp) return;
    _notifyByWhatsApp = value;
    notifyListeners();
  }

  void updateDefaultUrgency(String value) {
    if (value == _defaultUrgency) return;
    _defaultUrgency = value;
    notifyListeners();
  }

  void updateFormExpiryHours(int hours) {
    if (hours == _formExpiryHours) return;
    _formExpiryHours = hours;
    notifyListeners();
  }

  void toggleAutoAssignCollector(bool value) {
    if (value == _autoAssignCollector) return;
    _autoAssignCollector = value;
    notifyListeners();
  }

  void toggleAutoDeleteExpiredForms(bool value) {
    if (value == _autoDeleteExpiredForms) return;
    _autoDeleteExpiredForms = value;
    notifyListeners();
  }

  void toggleTwoFactor(bool value) {
    if (value == _enableTwoFactor) return;
    _enableTwoFactor = value;
    notifyListeners();
  }

  void updateSessionTimeout(int minutes) {
    if (minutes == _sessionTimeoutMinutes) return;
    _sessionTimeoutMinutes = minutes;
    notifyListeners();
  }

  void updateAcceptTerms(bool value) {
    if (value == _acceptTerms) return;
    _acceptTerms = value;
    _termsAcceptedAt = value ? DateTime.now() : null;
    notifyListeners();
  }

  void saveFeedback(String feedback) {
    _lastFeedback = feedback.trim();
    notifyListeners();
  }
}
