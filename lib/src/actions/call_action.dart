///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

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

  FCXCallAction._fromMap(Map<dynamic, dynamic> map)
      : this.callUuid = map != null ? map['callUuid'] : null,
        super._fromMap(map);

  Map<String, dynamic> _toMap() {
    var map = super._toMap();
    map.addAll({'callUuid': callUuid});
    return map;
  }
}