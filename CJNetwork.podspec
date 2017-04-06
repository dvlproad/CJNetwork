Pod::Spec.new do |s|
  s.name         = "CJNetwork"
  s.version      = "0.0.5"
  s.summary      = "一个AFNetworking应用的封装"
  s.homepage     = "https://github.com/dvlproad/CJNetwork"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "AFHTTPSessionManager+CJCategory_0.0.5" }
  # s.source_files  = "CJNetwork/**/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'SVProgressHUD', '~> 1.1.3'

  s.subspec 'AFHTTPSessionManager+CJCategory' do |ss|
    ss.source_files = "CJNetwork/AFHTTPSessionManager+CJCategory/**/*.{h,m}"

    ss.subspec 'CJNetworkMonitor' do |sss|
      sss.source_files = "CJNetwork/CJNetworkMonitor/**/*.{h,m}"
    end

    ss.subspec 'CJCacheManager' do |sss|
      sss.source_files = "CJCacheManager/**/*.{h,m}"
    end
  end

  s.subspec 'URLRequestUtil' do |ss|
    ss.source_files = "CJNetwork/URLRequestUtil/**/*.{h,m}"
  end

end
