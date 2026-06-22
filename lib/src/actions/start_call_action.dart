// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

part of 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';

/// Dart representation of CXStartCallAction from iOS CallKit Framework.
///
/// When the user initiates an outgoing call,
/// the provider calls [FCXProvider.performStartCallAction].
///
/// Handler of the [FCXProvider.performStartCallAction] callback calls
/// the [FCXAction.fulfill] method
/// to indicate that the action was successfully performed.
///
/// To indicate that the call started at a time other than the current time,
/// you can instead call the [FCXStartCallAction.fulfillWithDateStarted].
class FCXStartCallAction extends FCXCallAction {
  /// The handle of the call recipient.
  FCXHandle handle;

  /// The identifier for the call recipient.
  String? contactIdentifier;

  /// A bool value that indicates whether the call is a video call.
  bool video;

  /// Initializes a new action to start a call with the specified uuid
  /// to a recipient with the specified handle.
  FCXStartCallAction(super.callUuid, this.handle) : video = false;

  /// Reports the successful execution of the action at the specified time.
  /// A call is considered started when its invitation has been
  /// sent to the remote callee.
  Future<void> fulfillWithDateStarted(DateTime dateStarted) async {
    try {
      String method = 'fulfillWithDateStarted';
      await _methodChannel.invokeMethod(
        '$_action.$method',
        {'uuid': uuid, 'dateStarted': dateStarted.toIso8601String()},
      );
      _FCXLog._i(runtimeType, method);
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(runtimeType, exception);
      throw exception;
    }
  }

  FCXStartCallAction._fromMap(super.map)
      : handle = FCXHandle._fromMap(map['handle']),
        contactIdentifier = map['contactIdentifier'],
        video = map['video'],
        super._fromMap();

  @override
  Map<String, dynamic> _toMap() {
    var map = super._toMap();
    map.addAll({
      'handle': handle._toMap(),
      'contactIdentifier': contactIdentifier,
      'video': video
    });
    return map;
  }
}
