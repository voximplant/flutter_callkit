import 'package:flutter/material.dart';
import 'package:flutter_callkit_example/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'FlutterCallKit',
    home: MainScreen(),
  ));
}
