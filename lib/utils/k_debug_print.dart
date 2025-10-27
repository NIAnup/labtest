import 'package:flutter/foundation.dart';

class KDebugPrint {
  static const bool _isDebugMode = kDebugMode;
  
  /// Custom debug print that only works in debug mode
  static void print(String message, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '[DEBUG]';
      debugPrint('$tagPrefix $timestamp: $message');
    }
  }
  
  /// Print with error tag
  static void error(String message, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag-ERROR]' : '[ERROR]';
      debugPrint('$tagPrefix $timestamp: $message');
    }
  }
  
  /// Print with warning tag
  static void warning(String message, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag-WARNING]' : '[WARNING]';
      debugPrint('$tagPrefix $timestamp: $message');
    }
  }
  
  /// Print with info tag
  static void info(String message, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag-INFO]' : '[INFO]';
      debugPrint('$tagPrefix $timestamp: $message');
    }
  }
  
  /// Print with success tag
  static void success(String message, {String? tag}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag-SUCCESS]' : '[SUCCESS]';
      debugPrint('$tagPrefix $timestamp: $message');
    }
  }
  
  /// Print API related messages
  static void api(String message, {String? endpoint}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final endpointPrefix = endpoint != null ? '[$endpoint]' : '[API]';
      debugPrint('[API] $endpointPrefix $timestamp: $message');
    }
  }
  
  /// Print navigation related messages
  static void navigation(String message, {String? route}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final routePrefix = route != null ? '[$route]' : '[NAV]';
      debugPrint('[NAV] $routePrefix $timestamp: $message');
    }
  }
  
  /// Print form related messages
  static void form(String message, {String? formName}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final formPrefix = formName != null ? '[$formName]' : '[FORM]';
      debugPrint('[FORM] $formPrefix $timestamp: $message');
    }
  }
  
  /// Print provider related messages
  static void provider(String message, {String? providerName}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final providerPrefix = providerName != null ? '[$providerName]' : '[PROVIDER]';
      debugPrint('[PROVIDER] $providerPrefix $timestamp: $message');
    }
  }
  
  /// Print file operation messages
  static void file(String message, {String? fileName}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final filePrefix = fileName != null ? '[$fileName]' : '[FILE]';
      debugPrint('[FILE] $filePrefix $timestamp: $message');
    }
  }
  
  /// Print with custom tag
  static void custom(String message, String tag) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      debugPrint('[$tag] $timestamp: $message');
    }
  }
  
  /// Print object details
  static void object(String message, dynamic object) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      debugPrint('[OBJECT] $timestamp: $message');
      debugPrint('[OBJECT] $timestamp: ${object.toString()}');
    }
  }
  
  /// Print stack trace
  static void stackTrace(String message, StackTrace stackTrace) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      debugPrint('[STACK] $timestamp: $message');
      debugPrint('[STACK] $timestamp: $stackTrace');
    }
  }
}
