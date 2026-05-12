Pod::Spec.new do |s|
  #验证方法：pod lib lint CQVideoUrlAnalyze-Swift.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CQVideoUrlAnalyze-Swift"
  s.version      = "0.0.1"
  s.summary      = "视频地址解析库"
  s.homepage     = "https://github.com/dvlproad/CJNetwork"
  s.license      = "MIT"
  s.author       = "dvlproad"

  s.description  = <<-DESC
                 视频地址解析库，可按需独立引入：
                 • CQVideoUrlAnalyze-Swift/Douyin - 抖音
                 • CQVideoUrlAnalyze-Swift/Tiktok - Tiktok

                 每个子库可独立引入，详见各子库描述。
                 DESC

  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "9.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/dvlproad/CJUIKit.git", :tag => "CQVideoUrlAnalyze-Swift_0.0.1" }
  # s.source_files  = "CJBaseUtil/*.{h,m}"
  # s.resources = "CJBaseUtil/**/*.{png}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  # 抖音
  s.subspec 'Douyin' do |ss|
    ss.source_files = "CQVideoUrlAnalyze-Swift/Douyin/**/*.{swift}"
    ss.dependency 'CJNetworkClient/Request'
    ss.dependency 'CJNetwork-Swift/Download'
  end

  # Tiktok
  s.subspec 'Tiktok' do |ss|
    ss.source_files = "CQVideoUrlAnalyze-Swift/Tiktok/**/*.{swift}"
    ss.dependency 'CJNetworkClient/Request'
    ss.dependency 'CJNetwork-Swift/Download'
  end

end
