#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_callkit_voximplant.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_callkit_voximplant'
  s.version          = '2.3.0'
  s.summary          = 'Flutter SDK for CallKit integration to Flutter applications on iOS'
  s.homepage         = 'https://github.com/voximplant/flutter_callkit'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Zingaya Inc.' => 'mobiledev@zingaya.com'}
  s.source           = { :http => 'https://github.com/voximplant/flutter_callkit/' }
  s.source_files = 'flutter_callkit_voximplant/Sources/flutter_callkit_voximplant/**/*.{h,m}'
  s.public_header_files = 'flutter_callkit_voximplant/Sources/flutter_callkit_voximplant/include/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
