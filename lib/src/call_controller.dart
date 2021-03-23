///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of CXCallController from iOS CallKit Framework.
///
/// A [FCXCallController] object interacts with calls by performing actions,
/// which are represented by instances of [FCXCallAction] subclasses.
///
/// You can request that one or more actions be performed
/// in a single [FCXTransaction] object using the
/// [requestTransactionWithAction] or [requestTransactionWithActions].
///
/// A transaction may be rejected by the system for one of the reasons listed
/// in the [FCXCallKitRequestTransactionError] class.
///
/// [FCXCallController] object manages a [FCXCallObserver] object,
/// which can be accessed using the [callObserver] property.
///
/// You can provide a [FCXCallChanged] callback to the callObserver
/// in order to be notified of any changes to active calls.
///
/// A [FCXCallController] object is ready to use after initialized and
/// configured using [configure].
class FCXCallController {
  /// An observer for active calls.
  final FCXCallObserver callObserver;

  /// Creates CXCallController in native code.
  ///
  /// Must be used before any other interactions with [FCXCallController].
  Future<void> configure() async {
    try {
      String method = 'configure';
      await _methodChannel.invokeMethod('$_CALL_CONTROLLER.$method');
      _FCXLog._i(runtimeType, method);
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(runtimeType, exception);
      throw exception;
    }
  }

  /// Request a transaction containing the specified action to be performed
  /// by the in-app provider.
  ///
  /// A error indicates that the requested transaction could not be executed.
  ///
  /// Possible errors listed in the [FCXCallKitRequestTransactionError].
  Future<void> requestTransactionWithAction(FCXAction action) async {
    try {
      String method = 'requestTransactionWithAction';
      await _methodChannel.invokeMethod(
        '$_CALL_CONTROLLER.$method',
        action._toMap(),
      );
      _FCXLog._i(runtimeType, '$method: ${action.runtimeType}');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(runtimeType, exception);
      throw exception;
    }
  }

  /// Request a transaction containing the specified actions to be performed
  /// by the in-app provider.
  ///
  /// A error indicates that the requested transaction could not be executed.
  ///
  /// Possible errors listed in the [FCXCallKitRequestTransactionError].
  Future<void> requestTransactionWithActions(List<FCXAction> actions) async {
    try {
      String method = 'requestTransactionWithActions';
      await _methodChannel.invokeMethod(
        '$_CALL_CONTROLLER.$method',
        actions.map((f) => f._toMap()).toList(),
      );
      _FCXLog._i(runtimeType, '$method: $actions');
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(runtimeType, exception);
      throw exception;
    }
  }

  factory FCXCallController() => _cache ?? FCXCallController._internal();

  static FCXCallController? _cache;

  FCXCallController._internal() : callObserver = FCXCallObserver._internal() {
    _cache = this;
  }
}
