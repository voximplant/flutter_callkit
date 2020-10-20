///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of CXAnswerCallAction from iOS CallKit Framework.
///
/// When an incoming call is allowed by the system and approved by the user,
/// the provider calls [FCXProvider.performAnswerCallAction].
///
/// Handler of the [FCXProvider.performAnswerCallAction] callback calls
/// the [FCXAction.fulfill] method to indicate that
/// the action was successfully performed.
///
/// To indicate that the call connected at a time other than the current time,
/// you can instead call the [FCXAnswerCallAction.fulfillWithDateConnected].
class FCXAnswerCallAction extends FCXCallAction {
  /// Initializes a new action for a call identified by a given uuid.
  FCXAnswerCallAction(String callUuid) : super(callUuid);

  /// Reports the successful execution of the action at the specified time.
  /// A call is considered connected when both caller
  /// and callee can start communicating.
  Future<void> fulfillWithDateConnected(DateTime dateConnected) async {
    try {
      await _methodChannel.invokeMethod(
          '$_ACTION.fulfillWithDateConnected', <String, dynamic>{
        'uuid': uuid,
        'dateConnected': dateConnected?.toIso8601String()
      });
      _FCXLog._i('${runtimeType.toString()}.fulfillWithDateConnected');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  FCXAnswerCallAction._fromMap(Map<dynamic, dynamic> map) : super._fromMap(map);
}
