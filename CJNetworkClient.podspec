Pod::Spec.new do |s|
  #验证方法： pod lib lint CJNetworkClient.podspec --allow-warnings --use-libraries --verbose
  #提交方法： pod trunk push CJNetworkClient.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJNetworkClient"
  s.version      = "1.2.0"
  s.summary      = "网络请求的管理类：一个基于CJNetwork而封装的网络请求接口管理库"
  s.homepage     = "https://github.com/dvlproad/CJNetwork"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"
  s.description  = <<-DESC
                  - CJNetworkClient：网络请求的管理类，其他NetworkClient可通过本CJNetworkClient继承，也可自己再实现
                  

                   A longer description of CJNetworkClient in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CJNetworkClient_1.2.0_1" }
  # s.source_files  = "CJNetworkClient/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  # 网络请求的管理类，其他NetworkClient可通过本CJNetworkClient继承，也可自己再实现
  s.subspec 'CJNetworkClient' do |ss|
    ss.source_files = "CJNetworkClient/**/*.{h,m}"
    ss.dependency 'CJNetwork/AFNetworkingSerializerEncrypt'
    ss.dependency 'CJNetwork/AFNetworkingUploadComponent'
#    ss.dependency 'CQNetworkPublic/Client'
  end


end
