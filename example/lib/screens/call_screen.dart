///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/widgets/example_button.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';
import 'package:flutter_callkit_example/call.dart';

class CallScreen extends StatefulWidget {
  final bool _outgoing;

  CallScreen(this._outgoing);

  @override
  State<StatefulWidget> createState() => _CallScreenState(this._outgoing);
}

class _CallScreenState extends State<CallScreen> {
  final CallService _callService = CallService();
  final bool _outgoing;
  bool _muted = false;
  bool _onHold = false;

  _CallScreenState(this._outgoing) {
    _callService.callChangedEvent = callChanged;
  }

  @override
  void dispose() {
    super.dispose();
    _callService.callChangedEvent = null;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: ExampleColors.primary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 60),
            Text(
              '${_outgoing ? 'Outgoing' : 'Incoming'} call in progress',
              textAlign: TextAlign.center,
              style: TextStyle(color: CupertinoColors.white, fontSize: 30),
            ),
            SizedBox(height: 20),
            SizedBox(
              child: Text(
                '${_callService.callerName ?? ''}',
                style: TextStyle(color: CupertinoColors.white, fontSize: 25),
              ),
              height: 100,
            ),
            ExampleButton(_muted ? 'Unmute' : 'Mute', _muteOnTouch),
            ExampleButton(_onHold ? 'Resume' : 'Hold', _holdOnTouch),
            ExampleButton('Send DTMF', _dtmfOnTouch),
            ExampleButton('Hangup', _onHangupTouch)
          ],
        ),
      ),
    );
  }

  Future<void> _muteOnTouch() async {
    await _callService.mute();
  }

  Future<void> _holdOnTouch() async {
    await _callService.hold();
  }

  Future<void> _dtmfOnTouch() async {
    await _callService.sendDTMF('0');
  }

  Future<void> _onHangupTouch() async {
    await _callService.hangup();
  }

  void callChanged(Call? call) {
    if (call == null) {
      Navigator.pop(context);
    } else {
      setState(() {
        _muted = call.muted;
        _onHold = call.onHold;
      });
    }
  }
}
