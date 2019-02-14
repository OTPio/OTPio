platform :ios, '12.0'

source 'https://github.com/otpio/cocoapods'
source 'https://github.com/CocoaPods/Specs.git'

target 'otpio' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'LibToken'
  pod 'LibFA'

  pod 'Neon'
  pod 'Eureka'
  pod 'arek/Camera'
  pod 'MMDrawerController'

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Swinject'
  pod 'SwiftyUserDefaults', '4.0.0-alpha.1'

  post_install do |i|
    system("license-plist --output-path ./otpio/Resources/Settings.bundle --suppress-opening-directory --add-version-numbers")
  end

  target 'otpioTests' do
    inherit! :search_paths

    pod 'FontBlaster'
  end

end
