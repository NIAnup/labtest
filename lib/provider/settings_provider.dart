import 'package:flutter/material.dart';

/// Stores lab-level preferences that drive how the Blood Lab
/// experience behaves across the app. Values are kept locally
/// for now but the API allows wiring them to a backend later.
class SettingsProvider extends ChangeNotifier {
  // Lab profile
  String _labName = 'Acme Diagnostics';
  String _contactEmail = 'support@acmediagnostics.com';
  String _contactPhone = '+1 (555) 010-2030';

  // Notification preferences
  bool _notifyOnNewRequest = true;
  bool _notifyOnPendingAging = true;
  bool _dailySummaryEmail = false;

  // Workflow defaults
  String _defaultUrgency = 'Normal';
  int _formExpiryHours = 1;
  bool _autoAssignCollector = false;
  bool _autoDeleteExpiredForms = true;

  // Security preferences
  bool _enableTwoFactor = false;
  int _sessionTimeoutMinutes = 30;

  // Getters
  String get labName => _labName;
  String get contactEmail => _contactEmail;
  String get contactPhone => _contactPhone;

  bool get notifyOnNewRequest => _notifyOnNewRequest;
  bool get notifyOnPendingAging => _notifyOnPendingAging;
  bool get dailySummaryEmail => _dailySummaryEmail;

  String get defaultUrgency => _defaultUrgency;
  List<String> get urgencyOptions => const ['Normal', 'Urgent'];

  int get formExpiryHours => _formExpiryHours;
  List<int> get formExpiryOptions => const [1, 4, 8, 12, 24];

  bool get autoAssignCollector => _autoAssignCollector;
  bool get autoDeleteExpiredForms => _autoDeleteExpiredForms;

  bool get enableTwoFactor => _enableTwoFactor;
  int get sessionTimeoutMinutes => _sessionTimeoutMinutes;
  List<int> get sessionTimeoutOptions => const [15, 30, 60, 120];

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
}
