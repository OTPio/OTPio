platform :ios, '12.0'

target 'otpio' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git', :branch => 'wip/swift4'

  pod 'SwiftyUserDefaults', '4.0.0-alpha.1'

  pod 'OneTimePassword'
  pod 'Neon'
  pod 'QRCodeReader.swift'
  pod 'RetroProgress'
  pod 'FontBlaster'
  pod 'GradientProgressBar'
  pod 'SwipeCellKit'
  pod 'KeychainSwift'
  pod 'SCLAlertView'

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
