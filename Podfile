# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EdaYandex' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EdaYandex
  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
  pod 'Moya/RxSwift', '~> 11.0'
  pod 'RxSwiftUtilities', :git => 'https://github.com/RxSwiftCommunity/RxSwiftUtilities.git'
  pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'
  pod 'RxDataSources', '~> 3.0'
  pod 'RxOptional'
  pod 'SDWebImage', '~> 4.0'
  pod 'Nuke', '~> 7.0'
  pod 'Kingfisher', '~> 4.0'
  
  def testing_pods
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
    pod 'Quick'
    pod 'Nimble'
  end

  target 'EdaYandexTests' do
    inherit! :search_paths
    testing_pods
  end

  target 'EdaYandexUITests' do
    inherit! :search_paths
    testing_pods
  end

end
