// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

part of 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';

/// Dart representation of CXSetMutedCallAction from iOS CallKit Framework.
///
/// When the user or the system mutes a call,
/// the provider calls [FCXProvider.performSetMutedCallAction].
///
/// Handler of the [FCXProvider.performSetMutedCallAction] callback calls
/// the [FCXAction.fulfill] method to indicate that
/// the action was successfully performed.
///
/// When a caller mutes a call, that caller is unable to communicate
/// with other callers until they unmute the call.
///
/// A muted caller still receives communication from other unmuted callers.
class FCXSetMutedCallAction extends FCXCallAction {
  /// A bool value that indicates whether the call is muted.
  bool muted;

  /// Initializes a new action for a call identified by a given uuid,
  /// as well as whether the call is muted.
  FCXSetMutedCallAction(super.callUuid, this.muted);

  FCXSetMutedCallAction._fromMap(super.map)
      : muted = map['muted'],
        super._fromMap();

  @override
  Map<String, dynamic> _toMap() {
    var map = super._toMap();
    map.addAll({'muted': muted});
    return map;
  }
}
