//
//  CQVideoUrlAnalyze_Douyin.swift
//  CQVideoUrlAnalyze-Swift
//
//  Created by ciyouzen on 2020/2/25.
//  Copyright © 2020年 dvlproad. All rights reserved.
//
//  Douyin 的视频地址地址

import Foundation
import CJNetwork
import CJNetworkClient

@objc public class CQVideoUrlAnalyzeCleanHTTPSessionManager: AFHTTPSessionManager {
    public static let sharedInstance: CQVideoUrlAnalyzeCleanHTTPSessionManager = {
        return createSessionManager()
    }()

    static private func createSessionManager() -> CQVideoUrlAnalyzeCleanHTTPSessionManager {
        let manager = CQVideoUrlAnalyzeCleanHTTPSessionManager()
        
        let requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer = requestSerializer
        
        let responseSerializer = AFHTTPResponseSerializer()
        responseSerializer.acceptableContentTypes = Set([
            "text/plain",
            "text/html",
            "application/json",
            "application/json;charset=utf-8"
        ])
        manager.responseSerializer = responseSerializer
        
        manager.requestSerializer.willChangeValue(forKey: "timeoutInterval")
        manager.requestSerializer.timeoutInterval = 20.0
        manager.requestSerializer.didChangeValue(forKey: "timeoutInterval")
        
        return manager
    }
}

class CQVideoUrlAnalyzeNetworkClient: CJNetworkClient {
    static let sharedInstance: CQVideoUrlAnalyzeNetworkClient = {
        return CQVideoUrlAnalyzeNetworkClient()
    }()
    
    override init() {
        super.init()
        
        let cleanHTTPSessionManager = AFHTTPSessionManager.cqdemo()
        let cryptHTTPSessionManager = AFHTTPSessionManager.cqdemo()
        setupClean(cleanHTTPSessionManager, cryptHTTPSessionManager: cryptHTTPSessionManager)
  
        setupGetSuccessResponseModelBlock(
            { successNetworkInfo in
                guard let responseDictionary = successNetworkInfo.responseObject as? [String: Any] else {
                    return CJResponseModel()
                }
                
                let responseModel = CJResponseModel()
                responseModel.statusCode = responseDictionary["code"] as? Int ?? 0
                responseModel.message = responseDictionary["msg"] as? String
                
                var result = responseDictionary
                result.removeValue(forKey: "code")
                result.removeValue(forKey: "msg")
                responseModel.result = result
                responseModel.isCacheData = successNetworkInfo.isCacheData
                responseModel.cjNetworkLog = successNetworkInfo.networkLogString
                
                return responseModel
            }, checkIsCommonFailureBlock: { responseModel in
                if responseModel.statusCode == 5 { // For example: handling "account logged out"
                    // Handle common failure, like logging out
                    // CJToast.shortShowMessage("账号异地登录")
                    // CJDemoUserManager.sharedInstance.logout(true, completed: nil)
                    return true
                } else {
                    return false
                }
            }, getFailureResponseModelBlock: { failureRequestInfo in
                let errorMessage = failureRequestInfo.errorMessage.isEmpty ?? true
                ? NSLocalizedString("网络链接失败，请检查您的网络链接", comment: "")
                : failureRequestInfo.errorMessage
                
                let responseModel = CJResponseModel()
                responseModel.statusCode = -1
                responseModel.message = errorMessage
                responseModel.result = nil
                responseModel.cjNetworkLog = failureRequestInfo.networkLogString
                
                return responseModel
            }
        )
        
        self.baseUrl = "https://api.apiopen.top"
        self.simulateDomain = "http://localhost/simulateApi/CJDemoDataSimulationDemo"
    }
    
    // Add any required methods like `setupCleanHTTPSessionManager`, `setupGetSuccessResponseModelBlock`, etc.
}

@objc public class CQVideoUrlAnalyze_Douyin: NSObject {
    @objc public static func analyzeUrl(
        _ videoNetworkUrl: String,      // https://v.douyin.com/iPY4TLua/
        success: @escaping ((_ videoResultUrls: [String]) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ){
        getAnalyzeApi { analyzeApi in
            useApiToAnalyzeUrl(api: analyzeApi, Url: videoNetworkUrl, success: success, failure: failure)
        } failure: { errorMessage in
            failure(errorMessage)
        }
    }
    
    private static func getAnalyzeApi(
        success: @escaping ((_ analyzeApi: String) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        let manager: AFHTTPSessionManager = CQVideoUrlAnalyzeCleanHTTPSessionManager.sharedInstance
        let Url: String = "http://i.rcuts.com/update/247"   // 快捷指令：抖音解析 无水印
        let allParams: [String: Any] = [:]
        let headers: [String: String] = [:]
        manager.cj_requestUrl(Url, params: allParams, headers: headers, method: .GET, cacheSettingModel: nil, logType: .suppendWindow, progress: nil, success: { (successRequestInfo) in
            //guard let successRequestInfo = successRequestInfo else { return }
            
            //let message = "GET请求测试成功。。。\n\(successRequestInfo.networkLogString)"
            //debugPrint(message)
            if let responseDictionary: Dictionary<String, Any> = successRequestInfo.responseObject as? Dictionary<String, Any> {
                if let analyzeApi: String? = responseDictionary["api"] as! String, let analyzeApi = analyzeApi, analyzeApi.count > 0 {
                    success(analyzeApi)
                } else {
                    failure("获取解析的api失败")
                }
            } else {
                failure("获取解析的api失败")
            }
        }, failure: { (failureRequestInfo) in
            //guard let failureRequestInfo = failureRequestInfo else { return }
            
            let errorMessage = "GET请求测试失败。。。\n\(failureRequestInfo.errorMessage)"
            failure(errorMessage)
        })
        
    }
        
    private static func useApiToAnalyzeUrl(
        api: String, // "http://api.rcuts.com"
        Url: String, // https://v.douyin.com/iPY4TLua/
        success: @escaping ((_ videoResultUrls: [String]) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        let requestModel = CJRequestBaseModel()
        requestModel.ownBaseUrl = api                   // "http://api.rcuts.com"
        requestModel.apiSuffix = "Video/DouYin.php"
        requestModel.customParams = [
            "url": Url,                                 // https://v.douyin.com/iPY4TLua/
            "token": "rcuts"
        ]
        requestModel.requestMethod = .POST
        
        let settingModel = CJRequestSettingModel()
        // Uncomment if you need cache settings
        // let requestCacheModel = CJRequestCacheSettingModel()
        // requestCacheModel.cacheStrategy = .EndWithCacheIfExist
        // requestCacheModel.cacheTimeInterval = 10
        // settingModel.requestCacheModel = requestCacheModel
        settingModel.logType = .consoleLog
        requestModel.settingModel = settingModel
        
        CQVideoUrlAnalyzeNetworkClient.sharedInstance.requestModel(requestModel, success: { responseModel in
            if let responseDictionary = responseModel.result as? [String: Any],
               let videoResultUrls = responseDictionary["video_url"] as? [String],
               videoResultUrls.count > 0 {
                success(videoResultUrls)
            } else {
                failure("请求成功，但地址获取失败了")
            }
            
        }, failure: { isRequestFailure, errorMessage in
            failure(errorMessage)
        })
    }
}
