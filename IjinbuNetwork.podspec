Pod::Spec.new do |s|
	#验证方法：pod lib lint IjinbuNetwork.podspec --allow-warnings --use-libraries --verbose
  s.name         = "IjinbuNetwork"
  s.version      = "0.0.1"
  s.summary      = "ijinbu组件化开发 -- 网络模块"
  s.homepage     = "https://github.com/dvlproad/CJNetwork.git"

  #s.license      = "MIT"
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2016 dvlproad. All rights reserved.
    LICENSE
  }

  s.author   = { "dvlproad" => "" }
  

  s.description  = <<-DESC
  				        *、IjinbuNetwork：网络组件

                   A longer description of CJPopupAction in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  

  s.platform     = :ios, "8.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "IjinbuNetwork_0.0.1" }
  #s.source_files  = "CJCustomView/CJChat/*.{h,m}"
  #s.source_files = "CJChat/TestOSChinaPod.{h,m}"
  s.source_files = "IjinbuNetwork/**/*.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  s.dependency "CJNetwork/AFNetworkingBaseComponent"
  s.dependency 'CJNetwork/AFNetworkingUploadComponent'
  s.dependency "CJBaseUtil/CJDevice"
  s.dependency "OpenUDID"
  s.dependency "Mantle"
  s.dependency "CJBaseUIKit/UIImage+CJCategory"

end
