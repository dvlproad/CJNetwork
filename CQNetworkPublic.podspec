Pod::Spec.new do |s|
  # 目前传到github开源
  # pod trunk register 913168921@qq.com '913168921@qq.com' --description='homeMac'
  #验证方法： pod lib lint CQNetworkPublic.podspec --allow-warnings --use-libraries --verbose
  #提交方法： pod trunk push CQNetworkPublic.podspec --allow-warnings --use-libraries --verbose
  
  #验证方法1：pod lib lint CQNetworkPublic.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/dvlproadSpecs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CQNetworkPublic.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  #提交方法： pod repo push dvlproad CQNetworkPublic.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  s.name         = "CQNetworkPublic"
  s.version      = "0.3.0"
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
 
  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CQNetworkPublic_0.3.0" }
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
  



  # Request 普通请求
  s.subspec 'Request' do |ss|
    ss.subspec 'Base' do |sss|
      sss.source_files = "CQNetworkPublic/Request/Base/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Base'
    end

    # Helper 帮助工具类方法
    ss.subspec 'Helper' do |sss|
      sss.source_files = "CQNetworkPublic/Request/Helper/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Request/Base'
    end
    
    # Client 实例类方法
    ss.subspec 'Client' do |sss|
      sss.source_files = "CQNetworkPublic/Request/Client/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Request/Base'
    end
  end



  
  # Upload 上传请求
  s.subspec 'Upload' do |ss|
    ss.subspec 'Base' do |sss|
      sss.source_files = "CQNetworkPublic/Upload/Base/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Base'
      sss.dependency 'CJNetworkFileModel'
    end

    # Helper 帮助工具类方法
    ss.subspec 'Helper' do |sss|
      sss.source_files = "CQNetworkPublic/Upload/Helper/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Upload/Base'
    end
    
    # Client 实例类方法
    ss.subspec 'Client' do |sss|
      sss.source_files = "CQNetworkPublic/Upload/Client/**/*.{h,m}"
      sss.dependency 'CQNetworkPublic/Upload/Base'
    end
  end


end
