# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
source 'git@github.com:CocoaPods/Specs.git'
source 'git@github.com:applicaster/CocoaPods.git'
source 'git@github.com:applicaster/CocoaPods-Private.git'

target 'ZappAnalyticsPluginFirebase' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  ######## REMOVE THIS #######
  pod 'ZappPlugins', :git => 'git@github.com:applicaster/ZappPlugins-iOS.git', :branch => 'plugins_split'
  ######## REMOVE THIS #######

  # Pods for ZappAnalyticsPluginChartbeat
  #pod 'ZappPlugins'
  pod 'ZappAnalyticsPluginsSDK', :git => 'git@github.com:applicaster/ZappAnalyticsPluginsSDK-iOS.git', :branch => 'master'
  pod 'Firebase', '~> 4.12.0'

  target 'ZappAnalyticsPluginFirebaseTests' do
    # Pods for testing
  end
end
