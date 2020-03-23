///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit;

/// The types of events that generate dial tones.
enum FCXPlayDTMFCallActionType {
  /// The user tapped a digit on the in-call keypad.
  singleTone,
  /// The user included digits after a soft pause in their dial string.
  softPause,
  /// The user included digits after a hard pause in their dial string.
  hardPause
}

/// Dart representation of CXPlayDTMFCallAction from iOS CallKit Framework.
///
/// Whenever digits are transmitted during a call, whether
/// from a user interacting with a number pad or following a hard or soft pause,
/// the provider calls [FCXProvider.performPlayDTMFCallAction].
///
/// Handler of the [FCXProvider.performPlayDTMFCallAction] callback calls
/// the [FCXAction.fulfill] method to indicate that
/// the action was successfully performed.
///
/// The provider calls [FCXProvider.performPlayDTMFCallAction] for successive
/// actions only after the current action is fulfilled.
///
/// When interacting with the number pad, each entered digit
/// constitutes its own action.
///
/// Digits following a hard or soft pause, however,
/// are passed to [FCXProvider.performPlayDTMFCallAction] as
/// a single string of digits.
///
/// For example, if a user taps the 4 button on the number pad,
/// followed by the 2 button, the [FCXProvider.performPlayDTMFCallAction] called
/// for the digit 4 and waits for the action to be fulfilled;
/// after the action is fulfilled, the [FCXProvider.performPlayDTMFCallAction]
/// called for the digit 2.
///
/// CallKit automatically plays the corresponding DTMF frequencies
/// for any digits transmitted over a call.
///
/// The app is responsible for managing the timing and handling
/// of digits as part of fulfilling the action.
class FCXPlayDTMFCallAction extends FCXCallAction {

  /// The string representation of the digits
  /// that should be played as DTMF tones
  String digits;

  /// The type of the call action.
  FCXPlayDTMFCallActionType type;

  /// Initializes a new action for a call identified by a given uuid,
  /// as well as a specified type and sequence of digits.
  FCXPlayDTMFCallAction(String callUuid, this.digits, this.type)
      : super(callUuid);

  FCXPlayDTMFCallAction._fromMap(Map<dynamic, dynamic> map)
      : this.digits = map != null ? map['digits'] : null,
        this.type = map != null
            ? FCXPlayDTMFCallActionType.values[map['playDTMFCallActionType']]
            : null,
        super._fromMap(map);

  Map<String, dynamic> _toMap() {
    var map = super._toMap();
    map.addAll({'digits': digits, 'playDTMFCallActionType': type.index});
    return map;
  }
}
