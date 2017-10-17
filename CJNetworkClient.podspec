Pod::Spec.new do |s|
  s.name         = "CJNetworkClient"
  s.version      = "1.0.2"
  s.summary      = "一个网络请求接口库的管理和使用.在1.0.2版本这里停止使用，并改为pod‘CJNetwork’"
  s.homepage     = "https://github.com/dvlproad/CJNetwork"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CJNetwork_0.1.1" }
  s.source_files  = "CJNetwork/*.{h,m}"
  #s.resources = "CJFile/{png}"
  
  s.frameworks = 'UIKit'

  s.deprecated = true

end

