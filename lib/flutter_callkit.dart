///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

library flutter_callkit;

import 'dart:async';
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
part 'src/call_controller.dart';
part 'src/call_update.dart';
part 'src/call.dart';
part 'src/call_observer.dart';
part 'src/handle.dart';
part 'src/provider.dart';
part 'src/provider_configuration.dart';
part 'src/exceptions.dart';
part 'src/log.dart';

/// Signature for callbacks reporting push received and handled in native code.
///
/// [uuid] is the unique identifier of the call.
///
/// [callUpdate] is the [FCXCallUpdate] object passed to
/// reportNewIncomingCallWithUUID method in native code.
///
/// Used in [FCXPlugin].
typedef void FCXDidDisplayIncomingCall(String uuid, FCXCallUpdate callUpdate);

/// The entry point of the Flutter CallKit SDK.
class FCXPlugin {
    /// Get notified about push being received and handled in native code.
  FCXDidDisplayIncomingCall didDisplayIncomingCall;

    /// Used to adjust logging.
    static FCXLogLevel logLevel = FCXLogLevel.info;

    /// Process completion received with push notification.
    Future<void> processPushCompletion() async {
        try {
            await _methodChannel.invokeMethod('processPushCompletion');
            _FCXLog._i('pushCompletion processed');
        } on PlatformException catch (e) {
            _FCXLog._w(e.message);
        }
    }

    factory FCXPlugin() => _cache ?? FCXPlugin._internal();

    static FCXPlugin _cache;

    FCXPlugin._internal() {
        EventChannel('plugins.voximplant.com/plugin_events')
            .receiveBroadcastStream('plugin_events')
        .listen(_eventListener);
    _cache = this;
  }

  void _eventListener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    final String eventName = map['event'];

    _FCXLog._i('${runtimeType.toString()}.$eventName');
    if (eventName == 'didDisplayIncomingCall') {
      if (didDisplayIncomingCall != null) {
        String uuid = map['uuid'];
        FCXCallUpdate callUpdate = FCXCallUpdate._fromMap(map['callUpdate']);
        didDisplayIncomingCall(uuid, callUpdate);
      }
    }
  }
}

const MethodChannel _methodChannel =
    const MethodChannel('plugins.voximplant.com/flutter_callkit');

const String _PROVIDER = 'Provider';
const String _CALL_CONTROLLER = 'CallController';
const String _ACTION = 'Action';
const String _TRANSACTION = 'Transaction';