# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WeatherDress' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WeatherDress

  pod 'RxSwift'
  pod 'SwiftLint'
  pod 'SnapKit'  
  pod 'RxDataSources', '~> 5.0'
  pod 'lottie-ios'
  pod 'RealmSwift', '~> 10'

  target 'APINetworkingTests' do
    inherit! :search_paths
   
  pod 'RxSwift' 
  end

  target 'WeatherDressUseCaseTests' do
  pod 'RxSwift'
  pod 'RxTest'
  pod 'RxNimble', subspecs: ['RxBlocking', 'RxTest']
  end

  target 'WeatherDressUITests' do
    # Pods for testing
  end

end
