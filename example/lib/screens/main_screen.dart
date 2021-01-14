///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/screens/call_directory_menu_screen.dart';
import 'package:flutter_callkit_example/widgets/example_button.dart';
import 'package:flutter_callkit_example/screens/call_screen.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';

class MainScreen extends StatelessWidget {
  final CallService _callService = CallService();

  @override
  Widget build(BuildContext context) {
    Future<void> _incomingCall() async {
      await _callService.emulateIncomingCall('1111');
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, a1, a2) => CallScreen(false)),
      );
    }

    Future<void> _delayedIncomingCall() async {
      await Future.delayed(Duration(seconds: 3), _incomingCall);
    }

    Future<void> _outgoingCall() async {
      await _callService.emulateOutgoingCall('1111');
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, a1, a2) => CallScreen(true)),
      );
    }

    Future<void> _callDirectory() async {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a1, a2) => CallDirectoryMenuScreen(),
        ),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: ExampleColors.primary,
      child: Column(
        children: [
          SizedBox(height: 60),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'FlutterCallKit Example',
                style: TextStyle(color: CupertinoColors.white, fontSize: 30),
              ),
            ),
          ),
          ExampleButton('Outgoing call', _outgoingCall),
          ExampleButton('Incoming call', _incomingCall),
          ExampleButton('Delayed incoming call', _delayedIncomingCall),
          ExampleButton('CallDirectory', _callDirectory),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/voxlogo.png', width: 200.0),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
