Pod::Spec.new do |s|
  s.name         = "CommonASIUtil"
  s.version      = "0.0.3"
  s.summary      = "easier to use ASI."
  s.homepage     = "https://github.com/dvlproad/CommonAFNUtil"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "913168921@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/dvlproad/CommonAFNUtil.git", :tag => "0.0.3" }
  s.source_files  = "CommonASIUtil/**/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  s.dependency 'AFNetworking', '~> 2.5.4'
  s.dependency 'MBProgressHUD', '~> 0.9.1'
  s.dependency 'SVProgressHUD', '~> 1.1.3'
  s.dependency 'CommonDataCacheManager', '~> 0.0.2'

  s.subspec 'ServiceHelp' do |ss|
    ss.source_files = "ServiceHelp/**/*.{h,m}"
  end

end
