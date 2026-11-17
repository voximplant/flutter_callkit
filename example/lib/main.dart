// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_example/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
  );
  runApp(
    CupertinoApp(
      title: 'FlutterCallKit',
      home: MainScreen(),
    ),
  );
}
