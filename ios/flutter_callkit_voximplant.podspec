#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_callkit_voximplant.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_callkit_voximplant'
  s.version          = '2.0.2+2'
  s.summary          = 'Flutter SDK for CallKit integration to Flutter applications on iOS'
  s.homepage         = 'https://github.com/voximplant/flutter_callkit'
  s.license          = { :type => 'MIT',
                         :file => '../LICENSE' }
  s.author           = { 'Zingaya Inc.' => 'mobiledev@zingaya.com'}
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
