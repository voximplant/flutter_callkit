import 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';
import 'package:flutter_callkit_example/call.dart';

typedef CallChanged(Call call);

class CallService {
  factory CallService() {
    return _cache ?? CallService._internal();
  }

  static CallService _cache;

  CallService._internal()
      : _provider = FCXProvider(),
        _callController = FCXCallController() {
    _cache = this;
    _configure();
  }

  final FCXProvider _provider;
  final FCXCallController _callController;
  Call _managedCall;
  CallChanged callChangedEvent;
  bool _configured = false;

  String get callerName => _managedCall?.callerName;

  Future<void> emulateIncomingCall(String contactName) async {
    await _configure();

    _managedCall = Call(false, contactName);

    FCXCallUpdate callUpdate = FCXCallUpdate(
      remoteHandle: FCXHandle(FCXHandleType.Generic, contactName),
      supportsGrouping: false,
      supportsUngrouping: false,
      supportsHolding: true,
      supportsDTMF: true,
      hasVideo: false,
    );
    await _provider.reportNewIncomingCall(_managedCall.uuid, callUpdate);
  }

  //region Outgoing Call
  Future<void> emulateOutgoingCall(String contactName) async {
    await _configure();

    _managedCall = Call(true, contactName);

    FCXHandle handle = FCXHandle(FCXHandleType.Generic, contactName);

    FCXStartCallAction action = FCXStartCallAction(_managedCall.uuid, handle);
    action.contactIdentifier = 'Example contact ID';
    action.video = false;

    await _callController.requestTransactionWithAction(action);
  }
  //endregion

  //region Configuration
  Future<void> _configure() async {
    if (_configured) {
      return;
    }

    await _callController.configure();

    FCXProviderConfiguration configuration = FCXProviderConfiguration(
      'FlutterCallKit',
      includesCallsInRecents: true,
      supportsVideo: false,
      maximumCallsPerCallGroup: 1,
      supportedHandleTypes: {FCXHandleType.Generic},
    );

    await _provider.configure(configuration);

    _provider.performStartCallAction = (startCallAction) async {
      await _provider.reportOutgoingCall(_managedCall.uuid, null);
      await _provider.reportOutgoingCallConnected(_managedCall.uuid, null);
      await startCallAction.fulfill();
    };

    _provider.performEndCallAction = (endCallAction) async {
      _managedCall = null;
      await endCallAction.fulfill();
      if (callChangedEvent != null) {
        callChangedEvent(_managedCall);
      }
    };

    _provider.performAnswerCallAction = (answerCallAction) async {
      await answerCallAction.fulfill();
    };

    _provider.performPlayDTMFCallAction = (playDTMFCallAction) async {
      await playDTMFCallAction.fulfill();
    };

    _provider.performSetGroupCallAction = (setGroupCallAction) async {
      await setGroupCallAction.fulfill();
    };

    _provider.performSetHeldCallAction = (setHeldCallAction) async {
      _managedCall?.onHold = setHeldCallAction.onHold;
      await setHeldCallAction.fulfill();
      if (callChangedEvent != null) {
        callChangedEvent(_managedCall);
      }
    };

    _provider.performSetMutedCallAction = (setMutedCallAction) async {
      _managedCall?.muted = setMutedCallAction.muted;
      await setMutedCallAction.fulfill();
      if (callChangedEvent != null) {
        callChangedEvent(_managedCall);
      }
    };

    _callController.callObserver.callChanged = (call) async {
    };

    _configured = true;
  }

//endregion

  //region CallActions
  Future<void> mute() async {
    if (_managedCall == null) {
      throw Exception('Managed call is missing');
    }
    FCXSetMutedCallAction action =
        FCXSetMutedCallAction(_managedCall.uuid, !_managedCall.muted);
    await _callController.requestTransactionWithAction(action);
  }

  Future<void> hold() async {
    if (_managedCall == null) {
      throw Exception('Managed call is missing');
    }
    FCXSetHeldCallAction action =
        FCXSetHeldCallAction(_managedCall.uuid, !_managedCall.onHold);
    await _callController.requestTransactionWithAction(action);
  }

  Future<void> sendDTMF(String digits) async {
    if (_managedCall == null) {
      throw Exception('Managed call is missing');
    }
    FCXPlayDTMFCallAction action = FCXPlayDTMFCallAction(
        _managedCall.uuid, digits, FCXPlayDTMFCallActionType.singleTone);
    await _callController.requestTransactionWithAction(action);
  }

  Future<void> hangup() async {
    if (_managedCall == null) {
      throw Exception('Managed call is missing');
    }
    FCXEndCallAction action = FCXEndCallAction(_managedCall.uuid);
    await _callController.requestTransactionWithAction(action);
  }
//endregion
}