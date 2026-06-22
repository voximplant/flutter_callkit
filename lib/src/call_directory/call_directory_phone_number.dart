// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

part of 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';

/// Dart representation of 'FCXCallDirectoryPhoneNumber'
/// from the native iOS code.
///
/// Represents a phone number that might be blocked.
///
/// Used in [FCXPlugin_CallDirectoryExtension].
@immutable
class FCXCallDirectoryPhoneNumber {
  /// The phone number.
  final int number;

  /// Initializes a new object with the given phone number.
  const FCXCallDirectoryPhoneNumber(this.number);
}
