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
	pod 'MapboxMaps', '10.17.0'
  	pod 'MapboxNavigation', '~> 2.18'
	pod 'MapboxCoreNavigation', '~> 2.18'
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
post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.2'
    end
  end
end
