// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

part of 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';

/// Dart representation of `FCXIdentifiablePhoneNumber` from native iOS code.
///
/// Represents a phone number that might be blocked or identified.
///
/// Used in [FCXPlugin_CallDirectoryExtension].
@immutable
class FCXIdentifiablePhoneNumber extends FCXCallDirectoryPhoneNumber {
  /// The identification label of the phone number.
  final String label;

  /// Initializes a new object with the given phone number and label.
  const FCXIdentifiablePhoneNumber(
    super.number, {
    required this.label,
  });

  Map<String, dynamic> _toMap() => {'number': number, 'label': label};
}
