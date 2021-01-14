///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of `CXCallDirectoryManager.EnabledStatus`
/// from iOS CallKit Framework.
///
/// The enabled status of a Call Directory app extension,
/// as reported by the [FCXCallDirectoryManager.getEnabledStatus] method.
enum FCXCallDirectoryManagerEnabledStatus {
  /// Indicates that the enabled status for the extension is unknown.
  unknown,

  /// Indicates that the extension is disabled.
  disabled,

  /// Indicates that the extension is enabled.
  enabled
}

/// Dart representation of `CXCallDirectoryManager` from iOS CallKit Framework.
///
/// The class that manages a Call Directory app extension.
class FCXCallDirectoryManager {
  /// Returns the enabled status of the extension with the specified identifier.
  ///
  /// Possible errors listed in the [FCXCallKitCallDirectoryManagerError].
  static Future<FCXCallDirectoryManagerEnabledStatus> getEnabledStatus(
    String extensionIdentifier,
  ) async {
    try {
      String method = 'getEnabledStatus';
      int index = await _methodChannel.invokeMethod(
        '$_PLUGIN.$method',
        extensionIdentifier,
      );
      _FCXLog._i('$_self.$method');
      return FCXCallDirectoryManagerEnabledStatus.values[index];
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  /// Reloads the extension with the specified identifier.
  ///
  /// Possible errors listed in the [FCXCallKitCallDirectoryManagerError].
  static Future<void> reloadExtension(String extensionIdentifier) async {
    try {
      String method = 'reloadExtension';
      await _methodChannel.invokeMethod(
        '$_PLUGIN.$method',
        extensionIdentifier,
      );
      _FCXLog._i('$_self.$method');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  /// Opens the iOS Settings app and shows
  /// the Call Blocking & Identification settings.
  ///
  /// Before a Call Directory extension can operate on incoming calls,
  /// the user must explicitly enable the extension in the iOS Settings app.
  ///
  /// Possible errors listed in the [FCXCallKitCallDirectoryManagerError].
  static Future<void> openSettings() async {
    try {
      String method = 'openSettings';
      await _methodChannel.invokeMethod(
        '$_PLUGIN.$method',
      );
      _FCXLog._i('$_self.$method');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  static const _self = FCXCallDirectoryManager;
}
