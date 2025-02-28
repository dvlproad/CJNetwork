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
    case videoOriginal              // 原始视频
    case videoWithoutWatermark      // 视频有视频
    case videoWithoutWatermarkHD    // 视频无视频
    case imageCover  // 封面图片
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
                let resultUrl = getVideoInfo(for: type, videoId: videoId)    // 获取对应类型的 URL 模式并拼接视频 ID
                success(expandedUrl, videoId, resultUrl)
            } else {
                failure("获取短链重定向/扩展后的videoId失败")
            }
        } failure: { errorMessage in
            failure(errorMessage)
        }
    }
    
    @objc public static func getVideoInfo(for type: CQAnalyzeVideoUrlType, videoId: String) -> String {
        let baseUrl = "https://www.tikwm.com/video"
        
        switch type {
        case .audio:
            return "\(baseUrl)/music/\(videoId).mp3"
            
        case .videoOriginal:
            return "\(baseUrl)/media/play/\(videoId).mp4"
            
        case .videoWithoutWatermark:
            return "\(baseUrl)/media/wmplay/\(videoId).mp4"
            
        case .videoWithoutWatermarkHD:
            return "\(baseUrl)/media/hdplay/\(videoId).mp4"
            
        case .imageCover:
            return "\(baseUrl)/cover/\(videoId).webp"
        }
    }
}
