///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of CXCall from iOS CallKit Framework.
///
/// You don’t instantiate [FCXCall] objects directly.
/// Instead, [FCXCall] objects are created by the telephony provider
/// when an incoming call is received or an outgoing call is initiated.
///
/// Each [FCXCall] object is uniquely identified by a [uuid].
/// You primarily interact with calls by passing their unique identifiers
/// to Flutter CallKit APIs.
///
/// For example, to place a call on hold, you create an instance
/// of [FCXSetHeldCallAction] passing the uuid of the call and true,
/// and then pass the transaction to an instance of [FCXCallController]
/// using the [FCXCallController.requestTransactionWithAction].
///
/// You can use the [FCXCallObserver] managed by a [FCXCallController]
/// to access [FCXCall] instances for active calls
/// using the [FCXCallObserver.getCalls],
/// or provide a [FCXCallChanged] callback to the [FCXCallObserver].
class FCXCall {
  /// The unique identifier for the call.
  final String uuid;

  /// A bool value that indicates whether the call is outgoing.
  final bool outgoing;

  /// A bool value that indicates whether the call has connected.
  final bool hasConnected;

  /// A bool value that indicates whether the call has ended.
  final bool hasEnded;

  /// A bool value that indicates whether the call is on hold.
  final bool onHold;

  FCXCall._fromMap(Map<dynamic, dynamic> map)
      : uuid = map['uuid'],
        outgoing = map['outgoing'],
        onHold = map['onHold'],
        hasConnected = map['hasConnected'],
        hasEnded = map['hasEnded'];
}
