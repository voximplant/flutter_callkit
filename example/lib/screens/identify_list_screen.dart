///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';
import 'package:flutter_callkit_example/call_service.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';
import 'package:flutter_callkit_example/widgets/example_list.dart';

class IdentifyListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IdentifyListScreenState();
  }
}

class _IdentifyListScreenState extends State<IdentifyListScreen> {
  final CallService _callService = CallService();
  List<FCXIdentifiablePhoneNumber> _identifiedNumbers = [];
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _refreshNumbers();
  }

  Future<void> _refreshNumbers() async {
    var numbers = await _callService.getIdentifiedNumbers();
    if (mounted) {
      setState(() {
        _identifiedNumbers = numbers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _removeHandler(int index) async {
      Navigator.pop(context);
      FCXIdentifiablePhoneNumber selectedNumber = _identifiedNumbers[index];
      _callService.removeIdentifiedNumber(selectedNumber.number);
      await _refreshNumbers();
    }

    void _doneHandler() {
      Navigator.of(context).pop();
    }

    Future<void> _enterlabel(String number) {
      return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: CupertinoTextField(
              controller: _textController,
              placeholder: 'Enter label',
              autofocus: true,
              textInputAction: TextInputAction.done,
              onEditingComplete: () async {
                Navigator.pop(context);
                String label = _textController.text;
                _textController.text = '';
                try {
                  await _callService.addIdentifiedNumber(number, label);
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
                String number = _textController.text;
                _textController.text = '';
                await _enterlabel(number);
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
        title: 'Identifiable List',
        items: _identifiedNumbers
            .map((e) => '${e.number.toString()} - ${e.label}')
            .toList(),
        addHandler: _addHandler,
        removeHandler: _removeHandler,
        doneHandler: _doneHandler,
      ),
    );
  }
}
