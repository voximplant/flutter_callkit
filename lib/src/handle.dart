///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// The possible types of handles.
enum FCXHandleType {
  /// An unspecified type of handle.
  Generic,

  /// A phone number.
  PhoneNumber,

  /// An email address.
  EmailAddress
}

/// Dart representation of CXHandle from iOS CallKit Framework
///
/// A means by which a call recipient can be reached,
/// such as a phone number or email address.
///
/// When the telephony provider receives an incoming call or the user starts
/// an outgoing call, the other caller is identified by a CXHandle object.
///
/// For a caller identified by a phone number,
/// the handle type is [FCXHandleType.PhoneNumber] and the value is
/// a sequence of digits.
///
/// For a caller identified by an email address,
/// the handle type is [FCXHandleType.EmailAddress] and the value is
/// an email address.
///
/// For a caller identified in any other way,
/// the handle type is [FCXHandleType.Generic] and the value
/// typically follows some domain-specific format,
/// such as a username, numeric ID, or URL.
class FCXHandle {
  /// The type of the handle.
  final FCXHandleType type;

  /// The value of the handle.
  final String value;

  /// Initializes a new handle of a given type with the specified value.
  FCXHandle(this.type, this.value);

  FCXHandle._fromMap(Map<dynamic, dynamic> map)
      : this.type = FCXHandleType.values[map['type']],
        this.value = map['value'];

  Map<String, dynamic> _toMap() => {'type': type.index, 'value': value};
}
