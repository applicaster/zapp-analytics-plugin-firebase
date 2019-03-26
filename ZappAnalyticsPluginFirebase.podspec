Pod::Spec.new do |s|
  s.name             = "ZappAnalyticsPluginFirebase"
  s.version = '6.1.1'
  s.summary          = "ZappAnalyticsPluginFirebase"
  s.description      = <<-DESC
                        ZappAnalyticsPluginFirebase container.
                       DESC
  s.homepage         = "https://github.com/applicaster/ZappAnalyticsPlugins-iOS"
  s.license          = 'CMPS'
  s.author           = { "cmps" => "a.zchut@applicaster.com" }
  s.source           = { :git => "git@github.com:applicaster/ZappAnalyticsPlugins-iOS.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.static_framework = true

  s.public_header_files = 'ZappAnalyticsPluginFirebase/*.h'
  s.source_files = 'ZappAnalyticsPluginFirebase/**/*.{h,m,swift}', '"${PODS_ROOT}"/Firebase/**/*.{h}'

  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                          'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/Firebase/**',
                          'OTHER_LDFLAGS' => '$(inherited) -objc -framework "FirebaseCore" -framework "FirebaseInstanceID" -framework "FirebaseAnalytics"',
                          'ENABLE_BITCODE' => 'YES',
                          'SWIFT_VERSION' => '4.1',
                          'USER_HEADER_SEARCH_PATHS' => '"$(inherited)" "${PODS_ROOT}"/Firebase/**'
              }

  s.dependency 'ZappAnalyticsPluginsSDK'
  s.dependency 'Firebase', '= 5.18.0'
  s.dependency 'Firebase/Analytics'
end
