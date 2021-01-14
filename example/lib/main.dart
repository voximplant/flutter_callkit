///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_example/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
  );
  runApp(
    CupertinoApp(
      title: 'FlutterCallKit',
      home: MainScreen(),
    ),
  );
}
