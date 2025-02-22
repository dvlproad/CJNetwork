//
//  CQVideoUrlAnalyze_Tiktok.swift
//  CQVideoUrlAnalyze-Swift
//
//  Created by ciyouzen on 2020/2/25.
//  Copyright © 2020年 dvlproad. All rights reserved.
//
//  Tiktok 的视频地址地址

import Foundation
import CJNetwork

import Foundation

@objc public enum CQAnalyzeVideoUrlType: Int {
    case audio                      // 音频
    case originalVideo              // 原始视频
    case videoWithoutWatermark      // 视频有视频
    case videoWithoutWatermarkHD    // 视频无视频
    case imageCover  // 封面图片
    
    // 为了确保所有枚举都有合适的 URL 模式
    var urlPattern: String {
        switch self {
        case .audio:
            return "https://www.tikwm.com/video/music/"
        case .originalVideo:
            return "https://www.tikwm.com/video/media/wmplay/"
        case .videoWithoutWatermark:
            return "https://www.tikwm.com/video/media/play/"
        case .videoWithoutWatermarkHD:
            return "https://www.tikwm.com/video/media/hdplay/"
        case .imageCover:
            return "https://www.tikwm.com/video/cover/"
        }
    }
}

@objc public class CQVideoUrlAnalyze_Tiktok: NSObject {
    /// 从短链中获取指定类型的地址（先扩展短链、在获取id、再根据类型拼接得到最后地址)
    @objc public static func requestUrlFromShortenedUrl(
        _ shortenedUrl: String,
        type: CQAnalyzeVideoUrlType,
        success: @escaping ((_ expandedUrl: String, _ videoId: String, _ resultUrl: String) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        CJRequestUtil.expandShortenedUrl(shortenedUrl) { expandedUrl in
            if let videoId = (expandedUrl as NSString).cjnetworkUrl_Value(forKey: "video") {
                let resultUrl = type.urlPattern + videoId    // 获取对应类型的 URL 模式并拼接视频 ID
                success(expandedUrl, videoId, resultUrl)
            } else {
                failure("获取短链重定向/扩展后的videoId失败")
            }
        } failure: { errorMessage in
            failure(errorMessage)
        }
    }
    
    
    
}
