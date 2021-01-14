///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/screens/block_list_screen.dart';
import 'package:flutter_callkit_example/screens/identify_list_screen.dart';
import 'package:flutter_callkit_example/widgets/example_button.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';

class CallDirectoryMenuScreen extends StatelessWidget {
  final CallService _callService = CallService();

  final TextEditingController _textController = TextEditingController(
    text: 'Unknown',
  );

  @override
  Widget build(BuildContext context) {
    void _blockedNumbersHandler() => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a1, a2) => BlockListScreen(),
          ),
        );

    void _identifiedNumbersHandler() => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a1, a2) => IdentifyListScreen(),
          ),
        );

    Future<void> _openSettingsHandler() async =>
        await _callService.openSettings();

    Future<void> _reloadExtensionHandler() async =>
        await _callService.reloadExtension();

    Future<void> _getStatusHandler() async {
      String status = await _callService.getExtensionStatus();
      _textController.text = status;
      return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(_textController.text),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _doneHandler() {
      Navigator.of(context).pop();
    }

    return CupertinoPageScaffold(
      backgroundColor: ExampleColors.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          Text(
            'Call Directory',
            style: TextStyle(color: CupertinoColors.white, fontSize: 30),
          ),
          SizedBox(height: 20),
          ExampleButton('Blocked numbers', _blockedNumbersHandler),
          ExampleButton('Identified numbers', _identifiedNumbersHandler),
          ExampleButton('Open settings', _openSettingsHandler),
          ExampleButton('Reload extension', _reloadExtensionHandler),
          ExampleButton('Get status', _getStatusHandler),
          ExampleButton('Done', _doneHandler),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
