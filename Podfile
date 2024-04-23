# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MeetSerbia' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MeetSerbia

	pod 'Firebase/Core'
	pod 'Firebase/Database'
	pod 'Firebase/Auth'
	pod 'Firebase/Storage'
	pod 'SDWebImage'
	pod 'FloatingTabBarController'
	pod 'Kingfisher', '~> 7.0'
  	pod 'MapboxMaps', '10.11.1'
	pod 'MapboxCoreNavigation', '~> 2.11'
	pod 'MapboxNavigation', '~> 2.11'
	pod 'MapboxGeocoder.swift', '~> 0.15'	
	pod 'SwiftyGif'
	pod 'iProgressHUD', '~> 1.1.1'

  target 'MeetSerbiaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MeetSerbiaUITests' do
    # Pods for testing
  end


end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
