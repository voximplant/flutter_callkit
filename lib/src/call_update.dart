///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of CXCallUpdate from iOS CallKit Framework.
///
/// An encapsulation of new and changed information about a call.
///
/// [FCXCallUpdate] objects are used by the system to communicate
/// changes to calls over time.
///
/// Not every property on a [FCXCallUpdate] object must be set each time,
/// as each object includes only new and changed information.
/// For example, when a call is started, only some properties may be known
/// and included in the first [FCXCallUpdate] object sent to the system,
/// such as [localizedCallerName].
/// Later in the same call, other properties may change;
/// for example, a call may be upgraded from audio only to audio and video,
/// which would be reflected by a new [FCXCallUpdate] object with its [hasVideo]
/// property set to true.
///
/// When an incoming call is received, you construct a [FCXCallUpdate] object
/// specifying a [localizedCallerName] and pass that to the
/// [FCXProvider.reportNewIncomingCall] method to notify the telephony provider.
///
/// When an active call is updated, you construct a [FCXCallUpdate] object
/// specifying any updated information and pass that
/// to the [FCXProvider.reportCallUpdated] method.
///
/// For example, if a user changes their contact information during a call,
/// you could notify the telephony provider of this change
/// using a new [FCXCallUpdate] object with the new value
/// set to its [remoteHandle] property.
///
/// Any property that is not set will be ignored.
class FCXCallUpdate {
  /// The handle for the remote party (for an incoming call, this is the caller;
  /// for an outgoing call, this is the callee).
  FCXHandle? remoteHandle;

  /// Override the computed caller name to a provider-defined value.
  /// Normally the system will determine the appropriate caller name
  /// to display (e.g. using the user's contacts) based on the
  /// supplied caller identifier. Set this property to customize.
  String? localizedCallerName;

  /// Whether the call can be held on its own or swapped with another call.
  bool supportsHolding;

  /// Whether the call can be grouped (merged)
  /// with other calls when it is ungrouped.
  bool supportsGrouping;

  /// The call can be ungrouped (taken private) when it is grouped.
  bool supportsUngrouping;

  /// The call can send DTMF (dual tone multifrequency) tones
  /// via hard pause digits or in-call keypad entries.
  bool supportsDTMF;

  /// The call includes video in addition to audio.
  bool hasVideo;

  /// Creates [FCXCallUpdate] instance.
  FCXCallUpdate({
    this.remoteHandle,
    this.localizedCallerName,
    this.supportsHolding = false,
    this.supportsGrouping = false,
    this.supportsUngrouping = false,
    this.supportsDTMF = false,
    this.hasVideo = false,
  });

  Map<String, dynamic> _toMap() => {
        'remoteHandle': remoteHandle?._toMap(),
        'localizedCallerName': localizedCallerName,
        'supportsHolding': supportsHolding,
        'supportsGrouping': supportsGrouping,
        'supportsUngrouping': supportsUngrouping,
        'supportsDTMF': supportsDTMF,
        'hasVideo': hasVideo
      };

  FCXCallUpdate._fromMap(Map<dynamic, dynamic> map)
      : this.remoteHandle = FCXHandle._fromMap(map['remoteHandle']),
        this.localizedCallerName = map['localizedCallerName'],
        this.supportsHolding = map['supportsHolding'],
        this.supportsGrouping = map['supportsGrouping'],
        this.supportsUngrouping = map['supportsUngrouping'],
        this.supportsDTMF = map['supportsDTMF'],
        this.hasVideo = map['hasVideo'];
}
