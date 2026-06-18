// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/screens/call_directory_menu_screen.dart';
import 'package:flutter_callkit_example/widgets/example_button.dart';
import 'package:flutter_callkit_example/screens/call_screen.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';

class MainScreen extends StatelessWidget {
  final CallService _callService = CallService();

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> incomingCall() async {
      await _callService.emulateIncomingCall('1111');
      if (!context.mounted) {
        return;
      }
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, a1, a2) => const CallScreen(false)),
      );
    }

    Future<void> delayedIncomingCall() async {
      await Future.delayed(const Duration(seconds: 3), incomingCall);
    }

    Future<void> outgoingCall() async {
      await _callService.emulateOutgoingCall('1111');
      if (!context.mounted) {
        return;
      }
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, a1, a2) => const CallScreen(true)),
      );
    }

    void callDirectory() {
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
          const SizedBox(height: 60),
          const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'FlutterCallKit Example',
                style: TextStyle(color: CupertinoColors.white, fontSize: 30),
              ),
            ),
          ),
          ExampleButton('Outgoing call', outgoingCall),
          ExampleButton('Incoming call', incomingCall),
          ExampleButton('Delayed incoming call', delayedIncomingCall),
          ExampleButton('CallDirectory', callDirectory),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/voxlogo.png', width: 200.0),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
