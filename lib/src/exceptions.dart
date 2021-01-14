///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

class FCXException implements Exception {
  final String code;
  final String message;

  FCXException(this.code, this.message);

  @override
  String toString() => '$runtimeType($code, $message)';
}

/// Errors thrown by the plugin itself.
class FCXPluginError {
  static const String ERROR_CONFIGURATION_NOT_FOUND =
      'ERROR_CONFIGURATION_NOT_FOUND';
  static const String ERROR_PROVIDER_MISSING = 'ERROR_PROVIDER_MISSING';
  static const String ERROR_CALL_CONTROLLER_MISSING =
      'ERROR_CALL_CONTROLLER_MISSING';
  static const String ERROR_TRANSACTION_NOT_FOUND =
      'ERROR_TRANSACTION_NOT_FOUND';
  static const String ERROR_BUILDING_ACTION = 'ERROR_BUILDING_ACTION';
  static const String ERROR_ACTION_NOT_FOUND = 'ERROR_ACTION_NOT_FOUND';
  static const String ERROR_BUILDING_UUID = 'ERROR_BUILDING_UUID';
  static const String ERROR_UUID_NOT_FOUND = 'ERROR_UUID_NOT_FOUND';
  static const String ERROR_CALL_UPDATE_NOT_FOUND =
      'ERROR_CALL_UPDATE_NOT_FOUND';
  static const String ERROR_PUSH_COMPLETION_NOT_FOUND =
      'ERROR_PUSH_COMPLETION_NOT_FOUND';
  static const String ERROR_IMPLEMENTATION_NOT_FOUND =
      'ERROR_IMPLEMENTATION_NOT_FOUND';
  static const String ERROR_INVALID_ARGUMENTS = 'ERROR_INVALID_ARGUMENTS';
  static const String ERROR_LOW_IOS_VERSION = 'ERROR_LOW_IOS_VERSION';
  /// Handler for the call not found in native iOS code.
  static const String ERROR_HANDLER_NOT_REGISTERED =
      'ERROR_HANDLER_NOT_REGISTERED';
}

/// Errors thrown by the CallKit.
class FCXCallKitError {
  static const String ERROR_UNKNOWN = 'ERROR_UNKNOWN';
  static const String ERROR_UNENTITLED = 'ERROR_UNENTITLED';
  static const String ERROR_INVALID_ARGUMENT = 'ERROR_INVALID_ARGUMENT';
}

/// Errors thrown by the CallKit on incoming call.
class FCXCallKitIncomingCallError {
  static const String ERROR_UNKNOWN = 'ERROR_UNKNOWN';
  static const String ERROR_UNENTITLED = 'ERROR_UNENTITLED';
  static const String ERROR_CALLUUID_ALREADY_EXISTS =
      'ERROR_CALL_UUID_ALREADY_EXISTS';
  static const String ERROR_FILTERED_BY_DO_NOT_DISTURB =
      'ERROR_FILTERED_BY_DO_NOT_DISTURB';
  static const String ERROR_FILTERED_BY_BLOCK_LIST =
      'ERROR_FILTERED_BY_BLOCK_LIST';
}

/// Errors thrown by the CallKit on request transaction.
class FCXCallKitRequestTransactionError {
  static const String ERROR_UNKNOWN = 'ERROR_UNKNOWN';
  static const String ERROR_UNENTITLED = 'ERROR_UNENTITLED';
  static const String ERROR_UNKNOWN_CALL_PROVIDER =
      'ERROR_UNKNOWN_CALL_PROVIDER';
  static const String ERROR_EMPTY_TRANSACTION = 'ERROR_EMPTY_TRANSACTION';
  static const String ERROR_UNKNOWN_CALLUUID = 'ERROR_UNKNOWN_CALLUUID';
  static const String ERROR_CALLUUID_ALREADY_EXISTS =
      'ERROR_CALLUUID_ALREADY_EXISTS';
  static const String ERROR_INVALID_ACTION = 'ERROR_INVALID_ACTION';
  static const String ERROR_MAXIMUM_CALL_GROUPS_REACHED =
      'ERROR_MAXIMUM_CALL_GROUPS_REACHED';
}

/// Errors thrown by the CallKit on interacting with a call directory manager.
class FCXCallKitCallDirectoryManagerError {
  /// An unknown error occurred.
  static const String ERROR_UNKNOWN = 'ERROR_UNKNOWN';

  /// The call directory manager could not find a corresponding app extension.
  static const String ERROR_NO_EXTENSION_FOUND = 'ERROR_NO_EXTENSION_FOUND';

  /// The call directory manager was interrupted
  /// while loading the app extension.
  static const String ERROR_LOADING_INTERRUPTED = 'ERROR_LOADING_INTERRUPTED';

  /// The entries in the call directory are out of order.
  static const String ERROR_ENTRIES_OUT_OF_ORDER = 'ERROR_ENTRIES_OUT_OF_ORDER';

  /// There are duplicate entries in the call directory.
  static const String ERROR_DUPLICATE_ENTRIES = 'ERROR_DUPLICATE_ENTRIES';

  /// There are too many entries in the call directory.
  static const String ERROR_MAXIMUM_ENTRIES_EXCEEDED =
      'ERROR_MAXIMUM_ENTRIES_EXCEEDED';

  /// The call directory extension isn’t enabled by the system.
  static const String ERROR_EXTENSION_DISABLED = 'ERROR_EXTENSION_DISABLED';

  static const String ERROR_CURRENTLY_LOADING = 'ERROR_CURRENTLY_LOADING';
  static const String ERROR_UNEXPECTED_INCREMENTAL_REMOVAL =
      'ERROR_UNEXPECTED_INCREMENTAL_REMOVAL';
}
