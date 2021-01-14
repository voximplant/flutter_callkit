///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

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
  FCXCallDirectoryPhoneNumber(this.number);
}
