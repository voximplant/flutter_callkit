// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'src/transaction.dart';
part 'src/actions/action.dart';
part 'src/actions/call_action.dart';
part 'src/actions/start_call_action.dart';
part 'src/actions/answer_call_action.dart';
part 'src/actions/end_call_action.dart';
part 'src/actions/set_held_call_action.dart';
part 'src/actions/set_muted_call_action.dart';
part 'src/actions/set_group_call_action.dart';
part 'src/actions/play_dtmf_call_action.dart';
part 'src/call_directory/call_directory_extension.dart';
part 'src/call_controller.dart';
part 'src/call_update.dart';
part 'src/call.dart';
part 'src/call_observer.dart';
part 'src/handle.dart';
part 'src/provider.dart';
part 'src/provider_configuration.dart';
part 'src/exceptions.dart';
part 'src/log.dart';
part 'src/call_directory/call_directory_manager.dart';
part 'src/call_directory/call_directory_phone_number.dart';
part 'src/call_directory/identifiable_phone_number.dart';

/// Signature for callbacks reporting push received and handled in native code.
///
/// [uuid] is the unique identifier of the call.
/// Note that this value is uppercased by the CallKit.
///
/// [callUpdate] is the [FCXCallUpdate] object passed to
/// reportNewIncomingCallWithUUID method in native code.
///
/// Used in [FCXPlugin].
typedef FCXDidDisplayIncomingCall = void Function(
    String uuid, FCXCallUpdate callUpdate);

/// The entry point of the Flutter CallKit SDK.
class FCXPlugin {
  /// Get notified about push being received and handled in native code.
  FCXDidDisplayIncomingCall? didDisplayIncomingCall;

  /// Used to adjust logging.
  static FCXLogLevel logLevel = FCXLogLevel.info;

  /// Process completion received with push notification.
  Future<void> processPushCompletion() async {
    try {
      String method = 'processPushCompletion';
      await _methodChannel.invokeMethod('$_plugin.$method');
      _FCXLog._i(runtimeType, '$method done');
    } on PlatformException catch (e) {
      _FCXLog._w(runtimeType, e.message);
    }
  }

  factory FCXPlugin() => _cache ?? FCXPlugin._internal();
  static FCXPlugin? _cache;

  FCXPlugin._internal() {
    const EventChannel('plugins.voximplant.com/plugin_events')
        .receiveBroadcastStream()
        .listen(_eventListener);
    _cache = this;
  }

  void _eventListener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    final String? eventName = map['event'];
    _FCXLog._i(runtimeType, eventName);
    if (eventName == 'didDisplayIncomingCall') {
      String uuid = map['uuid'];
      FCXCallUpdate callUpdate = FCXCallUpdate._fromMap(map['callUpdate']);
      didDisplayIncomingCall?.call(uuid, callUpdate);
    }
  }
}

const MethodChannel _methodChannel =
    MethodChannel('plugins.voximplant.com/flutter_callkit');

const String _plugin = 'Plugin';
const String _provider = 'Provider';
const String _callController = 'CallController';
const String _action = 'Action';
const String _transaction = 'Transaction';
