import 'package:flutter/material.dart';
import 'package:flutter_callkit_example/theme/example_button.dart';
import 'package:flutter_callkit_example/screens/call_screen.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';

class MainScreen extends StatelessWidget {
  final CallService _callService = CallService();

  MainScreen();

  @override
  Widget build(BuildContext context) {
    Future<void> _incomingCall() async {
      await _callService.emulateIncomingCall('ExampleCallerName');

      Navigator.push(context,
          PageRouteBuilder(pageBuilder: (_, a1, a2) => CallScreen(false)));
    }

    Future<void> _delayedIncomingCall() async {
      await Future.delayed(Duration(seconds: 3), _incomingCall);
    }

    Future<void> _outgoingCall() async {
      await _callService.emulateOutgoingCall('ExampleCallerName');

      Navigator.push(context,
          PageRouteBuilder(pageBuilder: (_, a1, a2) => CallScreen(true)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterCallKit Example'),
        backgroundColor: ExampleColors.accent,
      ),
      body: (Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ExampleButton('Outgoing call', _outgoingCall),
            ExampleButton('Incoming call', _incomingCall),
            ExampleButton('Incoming call (with delay)', _delayedIncomingCall)
          ],
        ),
      )),
    );
  }
}
