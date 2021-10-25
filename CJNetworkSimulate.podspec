Pod::Spec.new do |s|
  #验证方法： pod lib lint CJNetworkSimulate.podspec --allow-warnings --use-libraries --verbose
  #提交方法： pod trunk push CJNetworkSimulate.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJNetworkSimulate"
  s.version      = "0.2.2"
  s.summary      = "一个网络模拟库（常用于为了功能快速开发中的临时网络模拟）"
  s.homepage     = "https://github.com/dvlproad/CJNetwork.git"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"
  s.description  = <<-DESC

                   A longer description of CJNetworkSimulate in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CJNetworkSimulate_0.2.2" }
  # s.source_files  = "CJNetworkSimulate/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  s.source_files = "CJNetworkSimulate/**/*.{h,m}"

end
