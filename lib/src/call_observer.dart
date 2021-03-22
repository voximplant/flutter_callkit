///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Signature for callbacks reporting when a call is changed.
///
/// Used in [FCXCallObserver].
typedef void FCXCallChanged(FCXCall call);

/// Dart representation of CXCallObserver from iOS CallKit Framework.
///
/// A programmatic interface for an object that manages a list of active calls
/// and observes call changes.
///
/// You can retrieve a list of active calls on an [FCXCallObserver] object
/// using the calls property.
///
/// You can also provide a [callChanged] callback
/// to respond to any active call changes.
///
/// [FCXCallObserver] object being created at the [FCXCallController] init,
/// and stored in the [FCXCallController.callObserver].
///
/// Direct initialisation is unavailable.
class FCXCallObserver {
  /// Callback for getting notified when a call is changed.
  FCXCallChanged? callChanged;

  /// Retrieve the current call list,
  /// blocking on initial state retrieval if necessary.
  Future<List<FCXCall>> getCalls() async {
    try {
      var data = await (_methodChannel.invokeListMethod<Map>(
        '$_CALL_CONTROLLER.getCalls',
      ) as FutureOr<List<Map<dynamic, dynamic>>>);
      _FCXLog._i('${runtimeType.toString()}.getCalls');
      return data.map((f) => FCXCall._fromMap(f)).toList();
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(exception);
      throw exception;
    }
  }

  FCXCallObserver._internal() {
    EventChannel('plugins.voximplant.com/call_controller_events')
        .receiveBroadcastStream('call_controller_events')
        .listen(_eventListener);
  }

  void _eventListener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    final String? eventName = map['event'];
    if (eventName == 'callChanged') {
      final FCXCall call = FCXCall._fromMap(map['call']);
      _FCXLog._i('${runtimeType.toString()}.$eventName: ${call.uuid}');
      callChanged?.call(call);
    } else {
      // TODO(vladimir): should be warning
      _FCXLog._i('${runtimeType.toString()}.$eventName');
    }
  }
}
