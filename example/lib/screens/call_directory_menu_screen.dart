// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/screens/block_list_screen.dart';
import 'package:flutter_callkit_example/screens/identify_list_screen.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';
import 'package:flutter_callkit_example/widgets/example_button.dart';

class CallDirectoryMenuScreen extends StatelessWidget {
  final CallService _callService = CallService();

  final TextEditingController _textController = TextEditingController(
    text: 'Unknown',
  );

  CallDirectoryMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void blockedNumbersHandler() => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a1, a2) => const BlockListScreen(),
          ),
        );

    void identifiedNumbersHandler() => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a1, a2) => const IdentifyListScreen(),
          ),
        );

    Future<void> openSettingsHandler() async =>
        await _callService.openSettings();

    Future<void> reloadExtensionHandler() async =>
        await _callService.reloadExtension();

    Future<void> getStatusHandler() async {
      String status = await _callService.getExtensionStatus();
      _textController.text = status;
      if (!context.mounted) {
        return;
      }
      return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(_textController.text),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void doneHandler() {
      Navigator.of(context).pop();
    }

    return CupertinoPageScaffold(
      backgroundColor: ExampleColors.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          const Text(
            'Call Directory',
            style: TextStyle(color: CupertinoColors.white, fontSize: 30),
          ),
          const SizedBox(height: 20),
          ExampleButton('Blocked numbers', blockedNumbersHandler),
          ExampleButton('Identified numbers', identifiedNumbersHandler),
          ExampleButton('Open settings', openSettingsHandler),
          ExampleButton('Reload extension', reloadExtensionHandler),
          ExampleButton('Get status', getStatusHandler),
          ExampleButton('Done', doneHandler),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
