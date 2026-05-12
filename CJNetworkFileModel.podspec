Pod::Spec.new do |s|
  #验证方法： pod lib lint CJNetworkFileModel.podspec --allow-warnings --use-libraries --verbose
  #提交方法： pod trunk push CJNetworkFileModel.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJNetworkFileModel"
  s.version      = "0.1.0"
  s.summary      = "要上传的文件的数据模型"
  s.homepage     = "https://github.com/dvlproad/CJNetwork.git"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"
  s.description  = <<-DESC
                  
                 要上传的文件的数据模型，可按需独立引入：
                 • CJNetworkFileModel/Upload - 要上传的文件的数据模型
                  会使用到该类的库目前有如下：
                      ①网络请求库 CJNetwork
                      ②图片选择上传库 CQImageAddDeleteListKit/AddDeletePickUpload

                 每个子库可独立引入，详见各子库描述。
                 DESC

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CJNetworkFileModel_0.1.0" }
  # s.source_files  = "CJNetworkFileModel/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  # 要上传的文件的数据模型
  s.subspec 'Upload' do |ss|
    ss.source_files = "CJNetworkFileModel/CJUploadFileModelsOwner/**/*.{h,m}"
    #ss.dependency 'CJNetworkFileModel/CJNetworkFileModelCommon'
  end


end
