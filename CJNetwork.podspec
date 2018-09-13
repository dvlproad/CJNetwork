Pod::Spec.new do |s|
  #验证方法：pod lib lint CJNetwork.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJNetwork"
  s.version      = "0.4.2"
  s.summary      = "一个AFNetworking应用的封装(支持加密和缓存数据)"
  s.homepage     = "https://github.com/dvlproad/CJNetwork"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CJNetwork_0.4.2" }
  s.source_files  = "CJNetwork/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  s.subspec 'CJNetworkBase' do |ss|
    ss.source_files = "CJNetwork/CJNetworkBase/**/*.{h,m}"
  end

  # 系统的请求方法
  s.subspec 'CJRequestUtil' do |ss|
    ss.source_files = "CJNetwork/CJRequestUtil/**/*.{h,m}"

    ss.dependency 'CJNetwork/CJNetworkBase'
  end

  # AFN的请求方法(已包含加密)
  s.subspec 'AFNetworkingBaseComponent' do |ss|
    ss.source_files = "CJNetwork/AFNetworkingBaseComponent/**/*.{h,m}"

    ss.dependency 'AFNetworking'
    ss.dependency 'CJNetwork/CJNetworkBase'
  end

  # 文件的上传请求方法(使用AFN)（子类会自称父类的s.dependency）
  s.subspec 'AFNetworkingUploadComponent' do |ss|
    ss.source_files = "CJNetwork/AFNetworkingUploadComponent/**/*.{h,m}"

    ss.dependency 'AFNetworking'
  end


  # 数据的缓存
  s.subspec 'CJCacheManager' do |ss|
    ss.source_files = "CJCacheManager/**/*.{h,m}"
  end


  # AFN的请求方法(包含缓存方法)
  s.subspec 'AFNetworkingCacheComponent' do |ss|
    ss.source_files = "CJNetwork/AFNetworkingCacheComponent/**/*.{h,m}"

    ss.dependency 'CJNetwork/AFNetworkingBaseComponent'
    ss.dependency 'CJNetwork/CJCacheManager'
  end

end
