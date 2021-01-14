///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of `FlutterCallkitPlugin` CallDirectory related methods
/// from the native iOS code.
///
/// Used to get easy access to the data storage of blocked/identified numbers
/// connected to the CallDirectory Extension.
///
/// When a phone number is blocked,
/// the system telephony provider will disallow incoming calls
/// from that phone number without displaying them to the user.
///
/// When a phone number has an identification entry,
/// incoming calls from that phone number will display
/// its associated label to the user.
///
/// To integrate CallDirectory Extension functionality to an application,
/// it is required:
/// - add a CallDirectory Extenstion to the XCode project.
/// - implement data storage for blocked and/or identifiable numders
///   in the native iOS code and connect it with CallDirectory Extension.
/// - assign `FlutterCallkitPlugin` CallDirectory related properties with
///   functions that access numbers storage.
///
/// See [example]() for an example of realisation and architecture details.
extension FCXPlugin_CallDirectoryExtension on FCXPlugin {

  /// Invokes `FlutterCallkitPlugin.getBlockedPhoneNumbers` property
  /// in the native iOS code and returns the list of blocked phone numbers.
  ///
  /// `FlutterCallkitPlugin.getBlockedPhoneNumbers` property must be
  /// assigned with a function that returns blocked numbers from your storage.
  ///
  /// If the property is not assigned in the native iOS code,
  /// [FCXPluginError.ERROR_HANDLER_NOT_REGISTERED] will be thrown.
  Future<List<FCXCallDirectoryPhoneNumber>> getBlockedPhoneNumbers() async {
    try {
      String method = 'getBlockedPhoneNumbers';
      List<dynamic> numbers = await _methodChannel.invokeMethod(
        '$_PLUGIN.$method',
      );
      _FCXLog._i('$runtimeType.$method');
      return numbers.map((f) => FCXCallDirectoryPhoneNumber(f)).toList();
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  /// Invokes `FlutterCallkitPlugin.didAddBlockedPhoneNumbers` property
  /// in the native iOS code with the given list of phone numbers to be handled
  /// as numbers to block.
  ///
  /// `FlutterCallkitPlugin.didAddBlockedPhoneNumbers` property must be
  /// assigned with a function that saves blocked numbers to your storage.
  ///
  /// If the property is not assigned in the native iOS code,
  /// [FCXPluginError.ERROR_HANDLER_NOT_REGISTERED] will be thrown.
  Future<void> addBlockedPhoneNumbers(
    List<FCXCallDirectoryPhoneNumber> numbers,
  ) async {
    try {
      String method = 'addBlockedPhoneNumbers';
      List<int> arguments = numbers.map((f) => f.number).toList();
      await _methodChannel.invokeMethod('$_PLUGIN.$method', arguments);
      _FCXLog._i('$runtimeType.$method: $arguments');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  /// Invokes `FlutterCallkitPlugin.didRemoveBlockedPhoneNumbers` property
  /// in the native iOS code with the given list of phone numbers to be handled
  /// as numbers to unblock.
  ///
  /// `FlutterCallkitPlugin.didRemoveBlockedPhoneNumbers` property must be
  /// assigned with a function that removes blocked numbers from your storage.
  ///
  /// If the property is not assigned in the native iOS code,
  /// [FCXPluginError.ERROR_HANDLER_NOT_REGISTERED] will be thrown.
  Future<void> removeBlockedPhoneNumbers(
    List<FCXCallDirectoryPhoneNumber> numbers,
  ) async {
    try {
      String method = 'removeBlockedPhoneNumbers';
      List<int> arguments = numbers.map((f) => f.number).toList();
      await _methodChannel.invokeMethod('$_PLUGIN.$method', arguments);
      _FCXLog._i('$runtimeType.$method: $arguments');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  /// Invokes `FlutterCallkitPlugin.didRemoveAllBlockedPhoneNumbers` property
  /// in the native iOS code.
  ///
  /// `FlutterCallkitPlugin.didRemoveAllBlockedPhoneNumbers` property must be
  /// assigned with a function that removes
  /// all blocked numbers from your storage.
  ///
  /// If the property is not assigned in the native iOS code,
  /// [FCXPluginError.ERROR_HANDLER_NOT_REGISTERED] will be thrown.
  Future<void> removeAllBlockedPhoneNumbers() async {
    try {
      String method = 'removeAllBlockedPhoneNumbers';
      await _methodChannel.invokeMethod('$_PLUGIN.$method');
      _FCXLog._i('$runtimeType.$method');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  /// Invokes `FlutterCallkitPlugin.getIdentifiablePhoneNumbers` property
  /// in the native iOS code and returns the list of identified phone numbers.
  ///
  /// `FlutterCallkitPlugin.getIdentifiablePhoneNumbers` property must be
  /// assigned with a function that returns
  /// identified numbers from your storage.
  ///
  /// If the property is not assigned in the native iOS code,
  /// [FCXPluginError.ERROR_HANDLER_NOT_REGISTERED] will be thrown.
  Future<List<FCXIdentifiablePhoneNumber>> getIdentifiablePhoneNumbers() async {
    try {
      String method = 'getIdentifiablePhoneNumbers';
      List<dynamic> numbers = await _methodChannel.invokeMethod(
        '$_PLUGIN.$method',
      );
      _FCXLog._i('$runtimeType.$method');
      return numbers.map((f) =>
          FCXIdentifiablePhoneNumber(f['number'], label: f['label'])).toList();
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  /// Invokes `FlutterCallkitPlugin.didAddIdentifiablePhoneNumbers` property
  /// in the native iOS code with the given list of phone numbers to be handled
  /// as numbers to identify.
  ///
  /// `FlutterCallkitPlugin.didAddIdentifiablePhoneNumbers` property must be
  /// assigned with a function that saves identified numbers to your storage.
  ///
  /// If the property is not assigned in the native iOS code,
  /// [FCXPluginError.ERROR_HANDLER_NOT_REGISTERED] will be thrown.
  Future<void> addIdentifiablePhoneNumbers(
    List<FCXIdentifiablePhoneNumber> numbers,
  ) async {
    try {
      String method = 'addIdentifiablePhoneNumbers';
      List<Map> arguments = numbers.map((f) => f._toMap()).toList();
      await _methodChannel.invokeMethod('$_PLUGIN.$method', arguments);
      _FCXLog._i('$runtimeType.$method: $arguments');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  /// Invokes `FlutterCallkitPlugin.didRemoveIdentifiablePhoneNumbers` property
  /// in the native iOS code with the given list of phone numbers to be handled
  /// as numbers to remove from identification list.
  ///
  /// `FlutterCallkitPlugin.didRemoveIdentifiablePhoneNumbers` property must be
  /// assigned with a function that removes identified numbers
  /// from your storage.
  ///
  /// If the property is not assigned in the native iOS code,
  /// [FCXPluginError.ERROR_HANDLER_NOT_REGISTERED] will be thrown.
  Future<void> removeIdentifiablePhoneNumbers(
    List<FCXCallDirectoryPhoneNumber> numbers,
  ) async {
    try {
      String method = 'removeIdentifiablePhoneNumbers';
      List<int> arguments = numbers.map((f) => f.number).toList();
      await _methodChannel.invokeMethod('$_PLUGIN.$method', arguments);
      _FCXLog._i('$runtimeType.$method: $arguments');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  /// Invokes `FlutterCallkitPlugin.didRemoveAllIdentifiablePhoneNumbers`
  /// property in the native iOS code.
  ///
  /// `FlutterCallkitPlugin.didRemoveAllIdentifiablePhoneNumbers`
  /// property must be assigned with a function that removes
  /// all identified numbers from your storage.
  ///
  /// If the property is not assigned in the native iOS code,
  /// [FCXPluginError.ERROR_HANDLER_NOT_REGISTERED] will be thrown.
  Future<void> removeAllIdentifiablePhoneNumbers() async {
    try {
      String method = 'removeAllIdentifiablePhoneNumbers';
      await _methodChannel.invokeMethod('$_PLUGIN.$method');
      _FCXLog._i('$runtimeType.$method');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }
}