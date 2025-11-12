import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:labtest/firebase_options.dart';
import 'package:labtest/utils/k_debug_print.dart';

const String _defaultLabId = 'default_lab';
const String _webVapidKey = String.fromEnvironment('FIREBASE_WEB_VAPID_KEY');

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  KDebugPrint.info(
    'Background FCM message received: ${message.messageId}',
    tag: 'PushNotificationService',
  );
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription<String>? _tokenSubscription;
  bool _autoInitEnabled = false;
  String _labId = _defaultLabId;
  bool _onMessageListenerAttached = false;

  Future<void> initialize({String? labId}) async {
    final sanitizedLabId = labId?.trim();
    if (sanitizedLabId != null && sanitizedLabId.isNotEmpty) {
      _labId = sanitizedLabId;
    }

    await _ensureAutoInit();
    await _requestPermission();
    await _refreshMessagingToken();

    _tokenSubscription ??= _messaging.onTokenRefresh.listen(
      (token) => _saveToken(token),
      onError: (Object error, StackTrace stackTrace) {
        KDebugPrint.error(
          'Error refreshing FCM token: $error',
          tag: 'PushNotificationService',
        );
        KDebugPrint.stackTrace(
          'FCM token refresh stack trace',
          stackTrace,
        );
      },
    );

    if (!_onMessageListenerAttached) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        KDebugPrint.info(
          'Foreground FCM message: ${message.messageId}',
          tag: 'PushNotificationService',
        );
      });
      _onMessageListenerAttached = true;
    }
  }

  Future<void> _ensureAutoInit() async {
    if (_autoInitEnabled) return;
    try {
      await _messaging.setAutoInitEnabled(true);
      _autoInitEnabled = true;
    } catch (e, stackTrace) {
      KDebugPrint.error(
        'Failed to enable FCM auto-init: $e',
        tag: 'PushNotificationService',
      );
      KDebugPrint.stackTrace(
        'Auto-init stack trace',
        stackTrace,
      );
    }
  }

  Future<void> _requestPermission() async {
    try {
      final settings = await _messaging.getNotificationSettings();

      if (settings.authorizationStatus == AuthorizationStatus.notDetermined ||
          settings.authorizationStatus == AuthorizationStatus.denied) {
        final granted = await _messaging.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          sound: true,
        );

        KDebugPrint.info(
          'FCM permission status: ${granted.authorizationStatus}',
          tag: 'PushNotificationService',
        );
      } else {
        KDebugPrint.info(
          'FCM permission already ${settings.authorizationStatus}',
          tag: 'PushNotificationService',
        );
      }
    } catch (e, stackTrace) {
      KDebugPrint.error(
        'Failed requesting FCM permission: $e',
        tag: 'PushNotificationService',
      );
      KDebugPrint.stackTrace(
        'FCM permission stack trace',
        stackTrace,
      );
    }
  }

  Future<void> _refreshMessagingToken() async {
    try {
      String? token;

      if (kIsWeb) {
        token = await _messaging.getToken(
          vapidKey: _webVapidKey.isNotEmpty ? _webVapidKey : null,
        );
      } else {
        token = await _messaging.getToken();
      }

      if (token == null || token.isEmpty) {
        KDebugPrint.warning(
          'FCM token was null or empty during refresh',
          tag: 'PushNotificationService',
        );
        return;
      }

      await _saveToken(token);
    } catch (e, stackTrace) {
      KDebugPrint.error(
        'Failed to refresh FCM token: $e',
        tag: 'PushNotificationService',
      );
      KDebugPrint.stackTrace(
        'Token refresh stack trace',
        stackTrace,
      );
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final tokensCollection =
          FirebaseFirestore.instance.collection('notification_tokens');

      await tokensCollection.doc(token).set(
        {
          'token': token,
          'labId': _labId,
          'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      KDebugPrint.success(
        'Stored FCM token for $_labId',
        tag: 'PushNotificationService',
      );
    } catch (e, stackTrace) {
      KDebugPrint.error(
        'Failed saving FCM token: $e',
        tag: 'PushNotificationService',
      );
      KDebugPrint.stackTrace(
        'Token save stack trace',
        stackTrace,
      );
    }
  }

  void dispose() {
    _tokenSubscription?.cancel();
    _tokenSubscription = null;
    _autoInitEnabled = false;
    _onMessageListenerAttached = false;
  }
}
