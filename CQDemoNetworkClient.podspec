  #验证方法1：pod lib lint CQDemoNetworkClient.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/dvlproadSpecs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CQDemoNetworkClient.podspec --sources=cocoapods,gitee-dvlproad-dvlproadspecs --allow-warnings --use-libraries --skip-import-validation --skip-tests --verbose
  #提交方法： pod repo push gitee-dvlproad-dvlproadspecs CQDemoNetworkClient.podspec --sources=cocoapods,gitee-dvlproad-dvlproadspecs --allow-warnings --use-libraries --verbose

Pod::Spec.new do |s|
  s.name         = "CQDemoNetworkClient"
  s.version      = "0.0.1"
  s.summary      = "演示Demo的无加密网络库"
  s.homepage     = "https://github.com/dvlproad/CJNetwork.git"

  #s.license      = "MIT"
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2020 dvlproad. All rights reserved.
    LICENSE
  }

  s.author   = { "dvlproad" => "" }
  

  s.description  = <<-DESC
                 演示Demo的无加密网络库-可以解耦底层，使得底层使用任意的网络框架，可按需独立引入：
                 • CQDemoNetworkClient/Base - Base 基础公共类
                 • CQDemoNetworkClient/Request - Request 普通请求
                 • CQDemoNetworkClient/Upload - Upload 上传请求

                 每个子库可独立引入，详见各子库描述。
                 DESC
  

  s.platform     = :ios, "9.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CQDemoNetworkClient_0.0.1" }
  #s.source_files  = "CJCustomView/CJChat/*.{h,m}"
  #s.source_files = "CJChat/TestOSChinaPod.{h,m}"
  #s.source_files = "CQDemoNetworkClient/**/*.{h,m}"
  #s.source_files = "CQDemoNetworkClient/**/*.*"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  
  s.source_files = "CQDemoNetworkClient/**/*.{h,m}"
  s.dependency 'CJNetworkClient/Base'
  
end
