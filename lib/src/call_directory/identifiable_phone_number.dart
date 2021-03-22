///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

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
  FCXIdentifiablePhoneNumber(
    int number, {
    required this.label,
  }) : super(number);

  Map<String, dynamic> _toMap() => {'number': number, 'label': label};
}
