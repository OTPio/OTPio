target 'otpio' do
  platform :ios, '12.0'

  use_frameworks!
  inhibit_all_warnings!

  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git', :branch => 'wip/swift4'

  pod 'SwiftyUserDefaults', '4.0.0-alpha.1'

  pod 'Neon'
  pod 'Observable', :git => "https://github.com/roberthein/Observable", :tag => "1.3.3"
  pod 'RetroProgress'
  pod 'FontBlaster'
  pod 'GradientProgressBar'
  pod 'SwipeCellKit'
  pod 'SCLAlertView'
  pod 'CryptoSwift'
  pod 'RetroProgress'
  pod 'arek/Camera'
  pod 'Eureka'
  pod 'KeychainAccess'
  pod 'NVActivityIndicatorView'
  pod 'Fabric'
  pod 'Crashlytics'

  pod 'libfa', :path => '../libfa'
  pod 'libtoken', :path => '../libtoken'

  post_install do |installer|
    system("license-plist --output-path ./otpio/Settings.bundle --suppress-opening-directory --add-version-numbers")
  end
end

target 'otpio-today' do
  platform :ios, '12.0'

  use_frameworks!
  inhibit_all_warnings!

  pod 'FontBlaster'
  pod 'Neon'
  pod 'KeychainAccess'

  pod 'libtoken', :path => '../libtoken'
end

target 'watch Extension' do
  platform :watchos, '5.0'

  pod 'KeychainAccess'
  pod 'SwiftBase32'
end
