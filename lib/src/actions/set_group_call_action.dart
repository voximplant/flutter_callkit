// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

part of 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';

/// Dart representation of CXSetGroupCallAction from iOS CallKit Framework.
///
/// When the user or the system groups a call with another call,
/// the provider calls [FCXProvider.performSetGroupCallAction].
///
/// Handler of the [FCXProvider.performSetGroupCallAction] callback calls
/// the [FCXAction.fulfill] method to indicate that
/// the action was successfully performed.
///
/// A group call allows more than two recipients
/// to simultaneously communicate with one another.
class FCXSetGroupCallAction extends FCXCallAction {
  /// The UUID of another call to group with.
  ///
  /// If the call for this action's UUID is already in a group,
  /// it should leave that group if necessary.
  /// If null, leave any group the call is currently in.
  String? callUUIDToGroupWith;

  /// Initializes a new action for a call identified by a given uuid,
  /// as well as a call to group with identified by another uuid.
  FCXSetGroupCallAction(super.callUuid, this.callUUIDToGroupWith);

  FCXSetGroupCallAction._fromMap(super.map)
      : callUUIDToGroupWith = map['callUUIDToGroupWith'],
        super._fromMap();

  @override
  Map<String, dynamic> _toMap() {
    var map = super._toMap();
    map.addAll({'callUUIDToGroupWith': callUUIDToGroupWith});
    return map;
  }
}
