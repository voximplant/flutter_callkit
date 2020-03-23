///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

part of flutter_callkit_voximplant;

/// Dart representation of CXProviderConfiguration from iOS CallKit Framework.
///
/// A [FCXProviderConfiguration] object controls the native call UI
/// for incoming and outgoing calls,
/// including a [localizedName] for the provider,
/// the ringtone to be played for incoming calls,
/// and the name of the icon to be displayed during calls.
///
/// A provider configuration can also set the maximum number of call groups
/// and number of calls in a single call group,
/// determine whether to use emails and/or phone numbers as handles,
/// and specify whether video is supported.
class FCXProviderConfiguration {
  /// Localized name of the provider.
  final String localizedName;

  /// Name of resource in app's bundle to play as ringtone for incoming call.
  String ringtoneSound;

  /// The name of resource for the icon image to be displayed for the provider.
  /// Image should be a square with side length of 40 points.
  String iconTemplateImageName;

  /// The maximum number of call groups.
  ///
  /// Default 2.
  int maximumCallGroups;

  /// The maximum number of calls per call group.
  ///
  /// Default 5.
  int maximumCallsPerCallGroup;

  /// Available since iOS 11.
  ///
  /// Whether this provider's calls should be included
  /// in the system's Recents list at the end of each call.
  ///
  /// Default true.
  bool includesCallsInRecents;

  /// Value that indicates Whether the provider supports video
  /// in addition to audio.
  ///
  /// Default false.
  bool supportsVideo;

  /// Handle types supported by the Provider.
  Set<FCXHandleType> supportedHandleTypes;

  FCXProviderConfiguration(this.localizedName,
      {this.ringtoneSound,
      this.iconTemplateImageName,
      this.maximumCallGroups = 2,
      this.maximumCallsPerCallGroup = 5,
      this.includesCallsInRecents = true,
      this.supportsVideo = false,
      this.supportedHandleTypes});

  Map<String, dynamic> _toMap() => {
        'localizedName': localizedName,
        'ringtoneSound': ringtoneSound,
        'iconTemplateImageName': iconTemplateImageName,
        'maximumCallGroups': maximumCallGroups,
        'maximumCallsPerCallGroup': maximumCallsPerCallGroup,
        'supportsVideo': supportsVideo,
        'supportedHandleTypes': _handleTypesToInt(supportedHandleTypes),
        'includesCallsInRecents': includesCallsInRecents,
      };

  List<int> _handleTypesToInt(Set<FCXHandleType> types) =>
      (types == null || types.isEmpty)
          ? []
          : types.map((f) => f.index).toList();
}
