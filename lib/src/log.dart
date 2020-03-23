///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Represents possible log levels of the [FCXPlugin].
enum FCXLogLevel {
  /// No logs.
  none,
  /// Only errors.
  error,
  /// Errors and warnings.
  warning,
  /// Errors, warnings and info.
  info
}

class _FCXLog {
  static void _e(FCXException e) => _log(_FCXLogType._error, '[${e.code}: ${e.message}]');
  static void _i(String message) => _log(_FCXLogType._info, message);
  static void _w(String message) => _log(_FCXLogType._warning, message);

  static void _log(_FCXLogType logType, String message) {
    if (FCXPlugin.logLevel._isLogTypeSupported(logType)) {
      print('[FlutterCallKit:${logType._prefix} > $message]');
    }
  }
}

extension _SupportedTypes on FCXLogLevel {
  List<_FCXLogType> get _supportedTypes {
    switch (this) {
      case FCXLogLevel.none:
        return [];
      case FCXLogLevel.error:
        return [_FCXLogType._error];
      case FCXLogLevel.warning:
        return [_FCXLogType._error, _FCXLogType._warning];
      case FCXLogLevel.info:
        return [_FCXLogType._info, _FCXLogType._error, _FCXLogType._warning];
      default:
        return [];
    }
  }

  bool _isLogTypeSupported(_FCXLogType type) {
    return this._supportedTypes.contains(type);
  }
}

enum _FCXLogType {
  _error,
  _warning,
  _info
}

extension _Prefix on _FCXLogType {
  String get _prefix {
    switch (this) {
      case _FCXLogType._error: return 'ERROR';
      case _FCXLogType._warning: return 'WARNING';
      case _FCXLogType._info: return 'INFO';
      default: return '';
    }
  }
}