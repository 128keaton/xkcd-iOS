# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

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
end

