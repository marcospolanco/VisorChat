# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'VisorChat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VisorChat
  pod 'Parse'
  pod 'ParseLiveQuery'
  pod 'MessengerKit', :git => 'https://github.com/steve228uk/MessengerKit.git'
  pod 'SwiftDate'

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

