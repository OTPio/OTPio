platform :ios, '12.0'

target 'otpio' do
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
  pod 'arek'
  pod 'Eureka'
  pod 'KeychainAccess'
  pod 'NVActivityIndicatorView'

  pod 'libfa', :path => '../libfa'
  pod 'libtoken', :path => '../libtoken'

  post_install do |installer|

    installer.pods_project.targets.each do |t|

      # Swift 4 support
      if[].include? t.name
        t.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.0'
        end
      end

      # Swift 3 support
      if[].include? t.name
        t.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.0'
        end
      end

    end
  end
end

target 'otpio-today' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'FontBlaster'
  pod 'Neon'
  pod 'KeychainAccess'

  pod 'libtoken', :path => '../libtoken'
end
