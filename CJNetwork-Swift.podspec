Pod::Spec.new do |s|
  # 验证方法：pod lib lint CJNetwork-Swift.podspec --allow-warnings --use-libraries --verbose
  # 上传方法：pod trunk push CJNetwork-Swift.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJNetwork-Swift"
  s.version      = "0.0.1"
  s.summary      = "主工程和其他Target某些工程下(WidgetExtension等)都需要依赖的库"
  s.homepage     = "https://github.com/dvlproad/CJNetwork.git"
  s.license      = "MIT"
  s.author       = "dvlproad"

  s.description  = <<-DESC
                   A longer description of CJNetwork-Swift in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "9.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CJNetwork-Swift_0.0.1" }
  # s.source_files  = "CJBaseUtil/*.{h,m}"
  # s.resources = "CJBaseUtil/**/*.{png}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  # 桌面组件
  s.subspec 'Download' do |ss|
    ss.source_files = "CJNetwork-Swift/Download/**/*.{swift}"
    ss.dependency 'SSZipArchive'
  end

end
