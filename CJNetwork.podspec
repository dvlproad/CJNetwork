Pod::Spec.new do |s|
  s.name         = "CJNetwork"
  s.version      = "0.0.3"
  s.summary      = "一个AFNetworking应用的封装"
  s.homepage     = "https://github.com/dvlproad/CJNetwork"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CJNetworkModels_0.0.3" }
  s.source_files  = "CJNetwork/**/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'SVProgressHUD', '~> 1.1.3'


  s.subspec 'CJNetworkHelper' do |ss|
    ss.source_files = "CJNetworkHelper/**/*.{h,m}"
  end

  s.subspec 'CJCacheManager' do |ss|
    ss.source_files = "CJCacheManager/**/*.{h,m}"
  end

  s.subspec 'CJNetworkModels' do |ss|
    ss.subspec 'CJUploadModels' do |sss|
      sss.source_files = "CJNetworkModels/CJUploadModels/**/*.{h,m}"
    end
  end

  


end
