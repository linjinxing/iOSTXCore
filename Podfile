# Uncomment this line to define a global platform for your project
platform :ios, '7.0'

workspace 'TXCoreApp'

xcodeproj 'TXAppShell/TXAppShell'
xcodeproj 'TXNetworking/TXNetworking'
xcodeproj 'TXUIKit/TXUIKit'


target :TXAppShell do
    xcodeproj 'TXAppShell/TXAppShell'
    pod 'AFNetworking'
    pod 'ReactiveCocoa'
    pod 'MJExtension'
    pod 'MBProgressHUD'
end

target :TXNetworking do
    xcodeproj 'TXNetworking/TXNetworking'
    pod 'AFNetworking'
    pod 'ReactiveCocoa'
    pod 'MJExtension'
end

target :TXUIKit do
    xcodeproj 'TXUIKit/TXUIKit'
    pod 'MBProgressHUD'
end

