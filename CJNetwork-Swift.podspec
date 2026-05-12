Pod::Spec.new do |s|
  #验证方法：pod lib lint CJNetwork-Swift.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJNetwork-Swift"
  s.version      = "0.0.1"
  s.summary      = "网络下载工具库(使用URLSession) - 可 ①下载普通文件 或者 ②下载zip文件并解压出内部文件"
  s.homepage     = "https://github.com/dvlproad/CJNetwork.git"
  s.license      = "MIT"
  s.author       = "dvlproad"

  s.description  = <<-DESC
                 网络下载工具库(使用URLSession) - 可 ①下载普通文件 或者 ②下载zip文件并解压出内部文件，可按需独立引入：
                 • CJNetwork-Swift/Download - 下载工具类(使用URLSession 可 ①下载普通文件 或者 ②下载zip文件并解压出内部文件)

                 每个子库可独立引入，详见各子库描述。
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

  # 下载工具类(使用URLSession 可 ①下载普通文件 或者 ②下载zip文件并解压出内部文件)
  s.subspec 'Download' do |ss|
    ss.source_files = "CJNetwork-Swift/Download/**/*.{swift}"
    ss.dependency 'SSZipArchive'
    ss.dependency 'Moya'
  end

end
