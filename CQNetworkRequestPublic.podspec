Pod::Spec.new do |s|
  # 为防止登录信息(如用户信息)变化时候，其他被依赖的库也要频繁跟着变化，这边将其独立出
  #验证方法1：pod lib lint CQNetworkRequestPublic.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/dvlproadSpecs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CQNetworkRequestPublic.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  #提交方法： pod repo push dvlproad CQNetworkRequestPublic.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  s.name         = "CQNetworkRequestPublic"
  s.version      = "0.0.1"
  s.summary      = "个人Demo模块化开发--登录模块"
  s.homepage     = "https://gitee.com/dvlproad/AppLoginCollect.git"

  #s.license      = "MIT"
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2020 dvlproad. All rights reserved.
    LICENSE
  }

  s.author   = { "dvlproad" => "" }
  

  s.description  = <<-DESC
                  - ViewModel:业务逻辑
  				        - UI:      UI
                  - Mediator:提供给外部的本模块控制器获取方法

                   A longer description of CQNetworkRequestPublic in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  

  s.platform     = :ios, "9.0"
 
  s.source       = { :git => "https://gitee.com/dvlproad/AppLoginCollect.git", :tag => "CQNetworkRequestPublic_0.0.1" }
  #s.source_files  = "CJCustomView/CJChat/*.{h,m}"
  #s.source_files = "CJChat/TestOSChinaPod.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  # 基础公共类
  s.subspec 'Base' do |ss|
    ss.source_files = "CQNetworkRequestPublic/Base/**/*.{h,m}"
  end
  
  
  # Helper 帮助工具类方法
  s.subspec 'Helper' do |ss|
    ss.subspec 'Request' do |sss|
      sss.source_files = "CQNetworkRequestPublic/Helper/Request/**/*.{h,m}"
      sss.dependency 'CQNetworkRequestPublic/Base'
    end
    
    ss.subspec 'Upload' do |sss|
      sss.source_files = "CQNetworkRequestPublic/Helper/Upload/**/*.{h,m}"
      sss.dependency 'CQNetworkRequestPublic/Base'
      sss.dependency 'CJNetworkFileModel'
    end
  end
  
  # Client 实例类方法
  s.subspec 'Client' do |ss|
    ss.subspec 'Request' do |sss|
      sss.source_files = "CQNetworkRequestPublic/Client/Request/**/*.{h,m}"
      sss.dependency 'CQNetworkRequestPublic/Base'
    end
    
    ss.subspec 'Upload' do |sss|
      sss.source_files = "CQNetworkRequestPublic/Client/Upload/**/*.{h,m}"
      sss.dependency 'CQNetworkRequestPublic/Base'
      sss.dependency 'CJNetworkFileModel'
    end
  end
  
  
  
  




end
