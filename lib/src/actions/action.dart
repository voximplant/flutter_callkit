///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of CXAction from iOS CallKit Framework.
///
/// An abstract class that declares a programmatic interface for
/// objects that represent a telephony action.
///
/// Each instance of [FCXAction] is uniquely identified by a uuid,
/// which is generated on initialization.
///
/// An action also tracks whether it has been completed or not.
/// To perform one or more actions, you pass the transaction to
/// an instance of [FCXCallController] using
/// the [FCXCallController.requestTransactionWithAction] method.
///
/// After each action is performed by the telephony provider,
/// the provider’s callback handler calls either the [FCXAction.fulfill] method,
/// indicating that the action was successfully performed,
/// or the [FCXAction.fail] method, to indicate that an error occurred;
/// both of these methods set the [FCXAction.complete] of the action to true.
abstract class FCXAction {
  /// The unique identifier for the action.
  String get uuid => _uuid;
  final String _uuid;

  /// A bool value that indicates whether
  /// the action has been performed by the provider.
  bool get complete => _complete;
  bool _complete;

  /// The time after which the action cannot be completed.
  DateTime get timeoutDate => _timeoutDate;
  final DateTime _timeoutDate;

  /// Initializes a new telephony action.
  ///
  /// Please note that with direct initialization
  /// `uuid` initialized as an empty string.
  /// The actual value of `uuid` is assigned in the iOS part of the plugin.
  FCXAction()
      : _complete = false,
        _timeoutDate = DateTime.now(),
        _uuid = '';

  /// Reports the successful execution of the action.
  Future<void> fulfill() async {
    try {
      String method = 'fulfill';
      await _methodChannel.invokeMethod('$_ACTION.$method', {'uuid': uuid});
      _complete = true;
      _FCXLog._i(runtimeType, method);
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(runtimeType, exception);
      throw exception;
    }
  }

  /// Reports the failed execution of the action.
  Future<void> fail() async {
    try {
      String method = 'fail';
      await _methodChannel.invokeMethod('$_ACTION.$method', {'uuid': uuid});
      _FCXLog._i(runtimeType, method);
    } on PlatformException catch (e) {
      var exception = FCXException(e.code, e.message);
      _FCXLog._e(runtimeType, exception);
      throw exception;
    }
  }

  FCXAction._fromMap(Map<dynamic, dynamic> map)
      : _uuid = map['uuid'],
        _complete = map['complete'],
        _timeoutDate = DateTime.parse(map['timeoutDate']);

  Map<String, dynamic> _toMap() => {'type': runtimeType.toString()};
}

extension _FCXActionMapDecodable on FCXAction {
  static FCXAction? _makeAction(Map<dynamic, dynamic> map) {
    switch (map['type']) {
      case 'CXStartCallAction':
        return FCXStartCallAction._fromMap(map);
      case 'CXAnswerCallAction':
        return FCXAnswerCallAction._fromMap(map);
      case 'CXEndCallAction':
        return FCXEndCallAction._fromMap(map);
      case 'CXSetMutedCallAction':
        return FCXSetMutedCallAction._fromMap(map);
      case 'CXSetHeldCallAction':
        return FCXSetHeldCallAction._fromMap(map);
      case 'CXPlayDTMFCallAction':
        return FCXPlayDTMFCallAction._fromMap(map);
      case 'CXSetGroupCallAction':
        return FCXSetGroupCallAction._fromMap(map);
      default:
        return null;
    }
  }
}
