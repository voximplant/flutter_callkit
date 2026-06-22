// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/call.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';
import 'package:flutter_callkit_example/widgets/example_button.dart';

class CallScreen extends StatefulWidget {
  final bool outgoing;

  const CallScreen(this.outgoing, {super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallService _callService = CallService();
  bool _muted = false;
  bool _onHold = false;

  @override
  void initState() {
    super.initState();
    _callService.callChangedEvent = callChanged;
  }

  @override
  void dispose() {
    _callService.callChangedEvent = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: ExampleColors.primary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 60),
            Text(
              '${widget.outgoing ? 'Outgoing' : 'Incoming'} call in progress',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: CupertinoColors.white, fontSize: 30),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: Text(
                _callService.callerName ?? '',
                style:
                    const TextStyle(color: CupertinoColors.white, fontSize: 25),
              ),
            ),
            ExampleButton(_muted ? 'Unmute' : 'Mute', _muteOnTouch),
            ExampleButton(_onHold ? 'Resume' : 'Hold', _holdOnTouch),
            ExampleButton('Send DTMF', _dtmfOnTouch),
            ExampleButton('Hangup', _onHangupTouch),
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
    if (!mounted) {
      return;
    }
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
