// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';

class ExampleButton extends StatelessWidget {
  final String _label;
  final VoidCallback _onPressed;

  const ExampleButton(String label, VoidCallback onPressed, {super.key})
      : _label = label,
        _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _onPressed,
          color: ExampleColors.button,
          child: Text(
            _label,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 19, color: CupertinoColors.white),
          ),
        ),
      ),
    );
  }
}
