///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of CXSetHeldCallAction from iOS CallKit Framework.
///
/// When a caller places a call on hold, callers are unable to communicate
/// with one another until the holding caller removes the call from hold.
///
/// Placing a call on hold does not end the call.
///
/// When the user or the system places a call on hold,
/// the provider calls [FCXProvider.performSetHeldCallAction].
///
/// Handler of the [FCXProvider.performSetHeldCallAction] callback calls
/// the [FCXAction.fulfill] method to indicate that
/// the action was successfully performed.
class FCXSetHeldCallAction extends FCXCallAction {

  /// A bool value that indicates whether the call is placed on hold.
  bool onHold;

  /// Initializes a new action for a call identified by a given uuid,
  /// as well as whether the call is on hold.
  FCXSetHeldCallAction(String callUuid, this.onHold) : super(callUuid);

  FCXSetHeldCallAction._fromMap(Map<dynamic, dynamic> map)
      : this.onHold = map['onHold'],
        super._fromMap(map);

  Map<String, dynamic> _toMap() {
    var map = super._toMap();
    map.addAll({'onHold': onHold});
    return map;
  }
}
