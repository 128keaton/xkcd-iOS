# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!
<<<<<<< HEAD

target 'XKCD' do
pod 'Gifu'
pod 'ReachabilitySwift', :git => 'https://github.com/ashleymills/Reachability.swift'
pod 'MBProgressHUD', '~> 0.9.2'
pod 'FetchKCD'
pod 'ImageScrollView', :git => 'https://github.com/huynguyencong/ImageScrollView.git'
end

target 'XKCDTests' do

=======
source 'https://github.com/CocoaPods/Specs.git'
def shared_pods
pod 'ImageScrollView'
pod 'FetchKCD'
end

target 'XKCD' do
shared_pods
pod 'MBProgressHUD'
pod 'Gifu'
pod 'ReachabilitySwift'
end

target 'Today\'s Comic' do
shared_pods
>>>>>>> origin/master
end

target 'XKCDUITests' do

end

