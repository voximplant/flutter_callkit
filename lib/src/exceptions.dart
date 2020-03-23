///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
///
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
  static const String ERROR_PROVIDER_MISSING =
      'ERROR_PROVIDER_MISSING';
  static const String ERROR_CALL_CONTROLLER_MISSING =
      'ERROR_CALL_CONTROLLER_MISSING';
  static const String ERROR_TRANSACTION_NOT_FOUND =
      'ERROR_TRANSACTION_NOT_FOUND';
  static const String ERROR_BUILDING_ACTION =
      'ERROR_BUILDING_ACTION';
  static const String ERROR_ACTION_NOT_FOUND =
      'ERROR_ACTION_NOT_FOUND';
  static const String ERROR_BUILDING_UUID =
      'ERROR_BUILDING_UUID';
  static const String ERROR_UUID_NOT_FOUND =
      'ERROR_UUID_NOT_FOUND';
  static const String ERROR_CALL_UPDATE_NOT_FOUND =
      'ERROR_CALL_UPDATE_NOT_FOUND';
  static const String ERROR_PUSH_COMPLETION_NOT_FOUND =
      'ERROR_PUSH_COMPLETION_NOT_FOUND';
  static const String ERROR_IMPLEMENTATION_NOT_FOUND =
      'ERROR_IMPLEMENTATION_NOT_FOUND';
}

/// Errors thrown by the CallKit.
class FCXCallKitError {
  static const String ERROR_UNKNOWN =
      'ERROR_UNKNOWN';
  static const String ERROR_UNENTITLED =
      'ERROR_UNENTITLED';
  static const String ERROR_INVALID_ARGUMENT =
      'ERROR_INVALID_ARGUMENT';
}

/// Errors thrown by the CallKit on incoming call.
class FCXCallKitIncomingCallError {
  static const String ERROR_UNKNOWN =
      'ERROR_UNKNOWN';
  static const String ERROR_UNENTITLED =
      'ERROR_UNENTITLED';
  static const String ERROR_CALLUUID_ALREADY_EXISTS =
      'ERROR_CALL_UUID_ALREADY_EXISTS';
  static const String ERROR_FILTERED_BY_DO_NOT_DISTURB =
      'ERROR_FILTERED_BY_DO_NOT_DISTURB';
  static const String ERROR_FILTERED_BY_BLOCK_LIST =
      'ERROR_FILTERED_BY_BLOCK_LIST';
}

/// Errors thrown by the CallKit on request transaction.
class FCXCallKitRequestTransactionError {
  static const String ERROR_UNKNOWN =
      'ERROR_UNKNOWN';
  static const String ERROR_UNENTITLED =
      'ERROR_UNENTITLED';
  static const String ERROR_UNKNOWN_CALL_PROVIDER =
      'ERROR_UNKNOWN_CALL_PROVIDER';
  static const String ERROR_EMPTY_TRANSACTION =
      'ERROR_EMPTY_TRANSACTION';
  static const String ERROR_UNKNOWN_CALLUUID =
      'ERROR_UNKNOWN_CALLUUID';
  static const String ERROR_CALLUUID_ALREADY_EXISTS =
      'ERROR_CALLUUID_ALREADY_EXISTS';
  static const String ERROR_INVALID_ACTION =
      'ERROR_INVALID_ACTION';
  static const String ERROR_MAXIMUM_CALL_GROUPS_REACHED =
      'ERROR_MAXIMUM_CALL_GROUPS_REACHED';
}