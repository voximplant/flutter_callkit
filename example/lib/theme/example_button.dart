import 'package:flutter/material.dart';
import 'package:flutter_callkit_example/theme/example_colors.dart';

class ExampleButton extends Padding {
  ExampleButton(String text, VoidCallback onPressed)
      : super(
          child: SizedBox(
            child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(14.0),
                ),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: onPressed,
                color: ExampleColors.button),
            height: 50,
            width: double.infinity,
          ),
          padding: EdgeInsets.all(10),
        );
}
