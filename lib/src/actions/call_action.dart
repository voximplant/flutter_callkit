// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

part of 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';

/// Dart representation of CXCallAction from iOS CallKit Framework.
///
/// The [FCXCallAction] is an abstract class that represents an action
/// associated with a [FCXCall] object.
/// The Flutter CallKit framework provides several concrete [FCXCallAction]
/// subclasses to represent actions such as answering a call
/// and putting a call on hold.
///
/// To perform one or more actions, you pass the transaction to an instance
/// of [FCXCallController] using
/// the [FCXCallController.requestTransactionWithActions] method.
///
/// After each action is performed by the telephony provider,
/// the [FCXProvider] callbacks fired and callbacks handler calls either
/// the [FCXAction.fulfill] method, indicating that the action was performed,
/// or the [FCXAction.fail] method, to indicate that an error occurred;
/// both of these methods set the [FCXAction.complete] of the action to true.
abstract class FCXCallAction extends FCXAction {
  /// The unique identifier of the call.
  final String callUuid;

  /// Initializes a new action for a call identified by a given uuid.
  FCXCallAction(this.callUuid);

  FCXCallAction._fromMap(super.map)
      : callUuid = map['callUuid'],
        super._fromMap();

  @override
  Map<String, dynamic> _toMap() {
    var map = super._toMap();
    map.addAll({'callUuid': callUuid});
    return map;
  }
}
