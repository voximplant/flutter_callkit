///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';
import 'package:flutter_callkit_example/widgets/example_list.dart';

class BlockListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BlockListScreenState();
  }
}

class _BlockListScreenState extends State<BlockListScreen> {
  final CallService _callService = CallService();
  List<String> _blockedNumbers = [];
  TextEditingController? _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _refreshNumbers();
  }

  Future<void> _refreshNumbers() async {
    var numbers = await _callService.getBlockedNumbers();
    if (mounted) {
      setState(() {
        _blockedNumbers = numbers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _removeHandler(int index) async {
      Navigator.pop(context);
      String selectedNumber = _blockedNumbers[index];
      _callService.removeBlockedNumber(selectedNumber);
      _blockedNumbers.remove(selectedNumber);
      await _refreshNumbers();
    }

    void _doneHandler() {
      Navigator.of(context).pop();
    }

    Future<void> _addHandler() {
      return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: CupertinoTextField(
              controller: _textController,
              placeholder: 'Enter phone number',
              autofocus: true,
              textInputAction: TextInputAction.done,
              onEditingComplete: () async {
                Navigator.pop(context);
                String? number = _textController?.text;
                _textController?.text = '';
                if (number == null) { return; }
                try {
                  await _callService.addBlockedNumber(number);
                  await _refreshNumbers();
                } catch (e) {
                  print('Error occured during adding: $e');
                }
              },
              keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
            ),
          );
        },
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: ExampleColors.primary,
      child: ExampleList(
        title: 'Block List',
        items: _blockedNumbers,
        addHandler: _addHandler,
        removeHandler: _removeHandler,
        doneHandler: _doneHandler,
      ),
    );
  }
}
