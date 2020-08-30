# frozen_string_literal: true

Pod::Spec.new do |s|
  s.name = 'ZappAnalyticsPluginFirebase'
  s.version = '8.3.0'
  s.platform = :ios, '11.0'
  s.summary = 'ZappAnalyticsPluginFirebase'
  s.description = 'ZappAnalyticsPluginFirebase container.'
  s.homepage = 'https://github.com/applicaster/zapp-analytics-plugin-firebase'
  s.license = 'CMPS'
  s.author = { 'cmps' => 'Applicaster LTD.' }
  s.source = { git: 'git@github.com:applicaster/zapp-analytics-plugin-firebase.git', tag: s.version.to_s }
  s.requires_arc = true
  s.static_framework = true

  s.public_header_files = '**/*.h'
  s.source_files = 'iOS/ZappAnalyticsPluginFirebase/**/*.{h,m,swift}', '"${PODS_ROOT}"/Firebase/**/*.{h}'

  s.xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                 'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/Firebase/**',
                 'OTHER_LDFLAGS' => '$(inherited) -objc -framework "FirebaseCore" -framework "FirebaseInstanceID" -framework "FirebaseAnalytics"',
                 'ENABLE_BITCODE' => 'YES',
                 'SWIFT_VERSION' => '5.1',
                 'USER_HEADER_SEARCH_PATHS' => '"$(inherited)" "${PODS_ROOT}"/Firebase/**' }

  s.dependency 'ZappAnalyticsPluginsSDK'
  s.dependency 'Firebase'
  s.dependency 'Firebase/Analytics'
  s.dependency 'FirebaseInstanceID'
  s.dependency 'ZappPlugins'
end
