///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';

class ExampleButton extends StatelessWidget {
  final String _label;
  final VoidCallback _onPressed;

  ExampleButton(String text, VoidCallback onPressed)
      : this._label = text,
        this._onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: SizedBox(
        child: CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Text(
            _label,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, color: CupertinoColors.white),
          ),
          onPressed: _onPressed,
          color: ExampleColors.button,
        ),
        height: 50,
        width: double.infinity,
      ),
    );
  }
}
