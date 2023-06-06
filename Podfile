# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '14.0'

target 'STYLiSH' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for STYLiSH
  
  pod 'Kingfisher'
  pod 'MJRefresh'
  pod 'IQKeyboardManagerSwift'
  pod 'JGProgressHUD'
  pod 'KeychainAccess'
  pod 'FBSDKLoginKit'
  pod 'SwiftLint'
  pod 'Alamofire'

  post_install do |installer|
          installer.pods_project.build_configurations.each do |config|
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
          end
    end
end
