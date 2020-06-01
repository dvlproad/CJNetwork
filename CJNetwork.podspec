Pod::Spec.new do |s|
  #验证方法：pod lib lint CJNetwork.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJNetwork"
  s.version      = "0.7.1-beta.1"
  s.summary      = "一个AFNetworking应用的封装(支持加解密、缓存、并发数控制)"
  s.homepage     = "https://github.com/dvlproad/CJNetwork"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"
  s.description  = <<-DESC
                  - CJNetwork/CJNetworkCommon：AFN请求过程中需要的几个公共方法(包含请求前获取缓存、请求后成功与失败操作)
                  - CJNetwork/AFNetworkingSerializerEncrypt：AFN的请求方法(加解密方法卸载Method方法中)
                  - CJNetwork/AFNetworkingMethodEncrypt：AFN的请求方法(加解密方法卸载Method方法中)
                  - CJNetwork/AFNetworkingUploadComponent：AFN的上传请求方法
                  - CJNetwork/CJNetworkClient：网络请求的管理类，其他NetworkClient可通过本CJNetworkClient继承，也可自己再实现
                  - CJNetwork/CJRequestUtil：原生(非AFN)的请求
                  - CJNetwork/CJCacheManager：自己实现的非第三方的缓存机制
                  

                   A longer description of CJNetwork in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CJNetwork_0.7.1-beta.1" }
  s.source_files  = "CJNetwork/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  s.subspec 'CJNetworkCommon' do |ss|
    ss.source_files = "CJNetwork/CJNetworkCommon/**/*.{h,m}"

    ss.dependency 'AFNetworking'
    ss.dependency 'YYCache'
    ss.dependency 'MJExtension'
  end


  # AFN的请求方法(加解密方法卸载Serializer方法中)
  s.subspec 'AFNetworkingSerializerEncrypt' do |ss|
    ss.source_files = "CJNetwork/AFNetworkingSerializerEncrypt/**/*.{h,m}"
    ss.dependency 'CJNetwork/CJNetworkCommon'
  end

  # AFN的请求方法(加解密方法卸载Method方法中)
  s.subspec 'AFNetworkingMethodEncrypt' do |ss|
    ss.source_files = "CJNetwork/AFNetworkingMethodEncrypt/**/*.{h,m}"
    ss.dependency 'CJNetwork/CJNetworkCommon'
  end

  # 文件的上传请求方法(使用AFN)（子类会自称父类的s.dependency）
  s.subspec 'AFNetworkingUploadComponent' do |ss|
    ss.source_files = "CJNetwork/AFNetworkingUploadComponent/**/*.{h,m}"
    ss.dependency 'CJNetwork/CJNetworkCommon'
  end

  # 网络请求的管理类，其他NetworkClient可通过本CJNetworkClient继承，也可自己再实现
  s.subspec 'CJNetworkClient' do |ss|
    ss.source_files = "CJNetwork/CJNetworkClient/**/*.{h,m}"
    ss.dependency 'CJNetwork/AFNetworkingSerializerEncrypt'
    ss.dependency 'CJNetwork/AFNetworkingUploadComponent'
  end

  # 系统的请求方法
  s.subspec 'CJRequestUtil' do |ss|
    ss.source_files = "CJNetwork/CJRequestUtil/**/*.{h,m}"

    ss.dependency 'CJNetwork/CJNetworkCommon'
  end

  # 数据的缓存
  s.subspec 'CJCacheManager' do |ss|
    ss.source_files = "CJCacheManager/**/*.{h,m}"
  end


end
