# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'VisorChat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VisorChat
  pod 'Parse'
  pod 'ParseLiveQuery'
  pod 'MessengerKit', :git => 'https://github.com/marcospolanco/MessengerKit.git'
  pod 'SwiftDate'
  pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'
  pod 'SwiftSpinner'
  pod 'SwiftyCam', :git => 'https://github.com/Awalz/SwiftyCam.git', :branch => 'Swift4'
  pod 'Cloudinary'
  pod 'SwipeableTabBarController'

end

post_install do | installer |
    installer.pods_project.targets.each do |target|
        if target.name.end_with? 'Bolts-Swift'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end

