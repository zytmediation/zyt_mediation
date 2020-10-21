#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mediation_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'zyt_mediation'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.ios.vendored_frameworks = ['Frameworks/ZYTSDK.framework','Frameworks/KSAdSDK.framework']
  s.vendored_frameworks = ['ZYTSDK.framework','KSAdSDK.framework']
  s.resources = ["Frameworks/AppLovinSDKResources.bundle",
                 "Frameworks/baidumobadsdk.bundle",
                 "Frameworks/BUAdSDK.bundle",
                 "Frameworks/TATMediaSDK.bundle",
                 "Frameworks/VideoXResource.bundle"]
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
