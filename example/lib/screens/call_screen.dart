import 'package:flutter/material.dart';
import 'package:flutter_callkit_example/theme/example_button.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';
import 'package:flutter_callkit_example/call.dart';

class CallScreen extends StatefulWidget {
  final bool _outgoing;

  CallScreen(this._outgoing);

  @override
  State<StatefulWidget> createState() {
    return _CallScreenState(this._outgoing);
  }
}

class _CallScreenState extends State<CallScreen> {
  final bool _outgoing;
  bool _muted = false;
  bool _onHold = false;
  CallService _callService = CallService();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('${_outgoing ? 'Outgoing' : 'Incoming'} call in progress'),
        automaticallyImplyLeading: false,
        backgroundColor: ExampleColors.accent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Text(
                '${_callService.callerName ?? ''}',
                style: TextStyle(fontSize: 30),
              ),
              height: 100,
            ),
            ExampleButton('${_muted ? 'Unmute' : 'Mute'}', _muteOnTouch),
            ExampleButton('${_onHold ? 'Resume' : 'Hold'}', _holdOnTouch),
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

  void callChanged(Call call) {
    if (call == null) {
        Navigator.maybePop(context);
    } else {
      setState(() {
        _muted = call.muted;
        _onHold = call.onHold;
      });
    }
  }
}
