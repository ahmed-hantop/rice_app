import 'dart:developer' as developer;
import 'package:logging/logging.dart';

/// Centralized logging service following Flutter best practices
class LoggingService {
  factory LoggingService() => _instance;
  LoggingService._internal();
  static final LoggingService _instance = LoggingService._internal();

  late final Logger _logger;

  /// Initialize the logging service
  void initialize({String name = 'TravelApp', Level level = Level.INFO}) {
    _logger = Logger(name);
    Logger.root.level = level;

    // Configure logging output
    Logger.root.onRecord.listen((record) {
      developer.log(
        record.message,
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
  }

  /// Log info message
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /// Log warning message
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  /// Log error message
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  /// Log debug message
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  /// Log network request
  void logNetworkRequest(
    String method,
    String url, {
    Map<String, dynamic>? data,
  }) {
    developer.log(
      'Network Request: $method $url',
      name: 'network.request',
      level: 800, // INFO level
    );
    if (data != null) {
      developer.log(
        'Request Data: $data',
        name: 'network.request.data',
        level: 700, // CONFIG level
      );
    }
  }

  /// Log network response
  void logNetworkResponse(
    String method,
    String url,
    int statusCode, {
    dynamic data,
  }) {
    developer.log(
      'Network Response: $method $url - Status: $statusCode',
      name: 'network.response',
      level: statusCode >= 400
          ? 1000
          : 800, // SEVERE for errors, INFO for success
    );
    if (data != null) {
      developer.log(
        'Response Data: $data',
        name: 'network.response.data',
        level: 700, // CONFIG level
      );
    }
  }

  /// Log user action
  void logUserAction(String action, {Map<String, dynamic>? context}) {
    developer.log(
      'User Action: $action',
      name: 'user.action',
      level: 800, // INFO level
    );
    if (context != null) {
      developer.log(
        'Action Context: $context',
        name: 'user.action.context',
        level: 700, // CONFIG level
      );
    }
  }

  /// Log navigation event
  void logNavigation(String from, String to) {
    developer.log(
      'Navigation: $from -> $to',
      name: 'navigation',
      level: 800, // INFO level
    );
  }

  /// Log performance metric
  void logPerformance(String operation, Duration duration) {
    developer.log(
      'Performance: $operation took ${duration.inMilliseconds}ms',
      name: 'performance',
      level: duration.inMilliseconds > 1000 ? 900 : 800, // WARNING if > 1s
    );
  }
}

/// Global logging instance
final logger = LoggingService();

/// Mixin for easy logging in classes
mixin LoggerMixin {
  LoggingService get logger => LoggingService();
}
