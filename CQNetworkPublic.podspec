Pod::Spec.new do |s|
  #验证方法1：pod lib lint CQNetworkPublic.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/dvlproadSpecs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CQNetworkPublic.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  #提交方法： pod repo push dvlproad CQNetworkPublic.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  s.name         = "CQNetworkPublic"
  s.version      = "0.1.0"
  s.summary      = "网络请求公共-可以解耦底层，使得底层使用任意的网络框架"
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
                  - Helper: 类方法
  				        - Client: 实例方法

                   A longer description of CQNetworkPublic in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  

  s.platform     = :ios, "9.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CQNetworkPublic_0.1.0" }
  #s.source_files  = "CJCustomView/CJChat/*.{h,m}"
  #s.source_files = "CJChat/TestOSChinaPod.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  # 基础公共类
  s.subspec 'Base' do |ss|
    ss.source_files = "CQNetworkPublic/Base/**/*.{h,m}"
  end
  
  
  # Helper 帮助工具类方法
  s.subspec 'Helper' do |ss|
    ss.subspec 'Request' do |sss|
      sss.source_files = "CQNetworkPublic/Helper/Request/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Base'
    end
    
    ss.subspec 'Upload' do |sss|
      sss.source_files = "CQNetworkPublic/Helper/Upload/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Base'
      sss.dependency 'CJNetworkFileModel'
    end
  end
  
  # Client 实例类方法
  s.subspec 'Client' do |ss|
    ss.subspec 'Request' do |sss|
      sss.source_files = "CQNetworkPublic/Client/Request/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Base'
    end
    
    ss.subspec 'Upload' do |sss|
      sss.source_files = "CQNetworkPublic/Client/Upload/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Base'
      sss.dependency 'CJNetworkFileModel'
    end
  end
  
  
  
  




end
