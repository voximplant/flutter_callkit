///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of CXEndCallAction from iOS CallKit Framework.
///
/// When the user ends a call,
/// the provider calls [FCXProvider.performEndCallAction].
///
/// Handler of the [FCXProvider.performEndCallAction] callback calls
/// the [FCXAction.fulfill] method to indicate that
/// the action was successfully performed.
///
/// To indicate that the call ended at a time other than the current time,
/// you can instead call the [FCXEndCallAction.fulfillWithDateEnded].
class FCXEndCallAction extends FCXCallAction {
  /// Initializes a new action for a call identified by a given uuid.
  FCXEndCallAction(String callUuid) : super(callUuid);

  /// Reports the successful execution of the action at the specified time.
  Future<void> fulfillWithDateEnded(DateTime dateEnded) async {
    try {
      await _methodChannel.invokeMethod(
        '$_ACTION.fulfillWithDateEnded',
        {'uuid': uuid, 'dateEnded': dateEnded?.toIso8601String()},
      );
      _FCXLog._i('${runtimeType.toString()}.fulfillWithDateEnded');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  FCXEndCallAction._fromMap(Map<dynamic, dynamic> map) : super._fromMap(map);
}
