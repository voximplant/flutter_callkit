///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class Call {
  final String uuid;
  final bool outgoing;
  final String callerName;
  bool muted = false;
  bool onHold = false;

  Call(this.outgoing, this.callerName) : uuid = _uuid.v4();
}
