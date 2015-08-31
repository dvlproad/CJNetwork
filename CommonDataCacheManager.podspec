Pod::Spec.new do |s|
  s.name         = "CommonDataCacheManager"
  s.version      = "0.0.2"
  s.summary      = "a manager to make data cache."
  s.homepage     = "https://github.com/dvlproad/CommonAFNUtil"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "913168921@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/dvlproad/CommonAFNUtil.git", :tag => "0.0.2" }
  s.source_files  = "CommonDataCacheManager/**/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
