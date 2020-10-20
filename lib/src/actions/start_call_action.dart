///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

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
  String contactIdentifier;

  /// A bool value that indicates whether the call is a video call.
  bool video;

  /// Initializes a new action to start a call with the specified uuid
  /// to a recipient with the specified handle.
  FCXStartCallAction(String callUuid, this.handle) : super(callUuid);

  /// Reports the successful execution of the action at the specified time.
  /// A call is considered started when its invitation has been
  /// sent to the remote callee.
  Future<void> fulfillWithDateStarted(DateTime dateStarted) async {
    try {
      await _methodChannel.invokeMethod('$_ACTION.fulfillWithDateStarted',
          {'uuid': uuid, 'dateStarted': dateStarted?.toIso8601String()});
      _FCXLog._i('${runtimeType.toString()}.fulfillWithDateStarted');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  FCXStartCallAction._fromMap(Map<dynamic, dynamic> map)
      : this.handle = map != null ? FCXHandle._fromMap(map['handle']) : null,
        this.contactIdentifier = map != null ? map['contactIdentifier'] : null,
        this.video = map != null ? map['video'] : null,
        super._fromMap(map);

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
