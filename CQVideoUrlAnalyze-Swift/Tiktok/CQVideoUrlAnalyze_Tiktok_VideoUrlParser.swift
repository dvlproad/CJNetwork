//
//  CQVideoUrlAnalyze_Tiktok.swift
//  CQVideoUrlAnalyze-Swift
//
//  Created by ciyouzen on 2020/2/25.
//  Copyright © 2020年 dvlproad. All rights reserved.
//
//  Tiktok 的视频地址地址

import Foundation
import CJNetwork_Swift

@objc(VideoFileUrl)
public class VideoFileUrl: NSObject {
    @objc let url: NSString
    
    @objc init(url: NSString) {
        self.url = url
    }
}

@objc public class ActualVideoPageUrl: NSObject {
    let url: String?
    let fullResponse: String
    
    @objc init(url: String?, fullResponse: String) {
        self.url = url
        self.fullResponse = fullResponse
    }
}

@objc public class TikTokService: NSObject {
//    @objc public static func getAndDownloadFromShortenedUrl(
//        _ shortenedUrl: String,
//        success: @escaping (_ cacheURL: URL) -> Void,
//        failure: @escaping (NSError) -> Void
//    ) {
//        getActualVideoUrlFromShortenedUrl(shortenedUrl, success:{ actualVideoUrl in
//            downloadAccessRestrictedDataFromActualVideoUrl(actualVideoUrl as String) { cacheURL in
//                success(cacheURL)
//            } failure: { error in
//                failure(error)
//            }
//
//        }, failure: { error in
//            failure(error)
//        })
//    }

    
    /// 下载没有访问权限的数据（即把视频地址复制到浏览器没法浏览的）
    @objc public static func downloadAccessRestrictedDataFromActualVideoUrl(
        _ actualVideoUrl: String,
        saveToLocalURLGetter: @escaping (_ videoFileExtension: String) -> URL, // 视频存放到的本地地址
        progress: ((_ written: Int64, _ total: Int64, _ percentage: CGFloat) -> Void)? = nil, // 进度回调
        success: @escaping (_ cacheURL: URL) -> Void,
        failure: @escaping (NSError) -> Void
    ) {
        getVideoDataFromActualVideoUrl(actualVideoUrl, success: { contentType, videoData in
            let videoFileExtension = contentType?.subtype ?? "mp4"
            let fileLocalURL = saveToLocalURLGetter(videoFileExtension)
            CJDownloadDataSaveUtil.downloadFileData(videoData, fileLocalURL: fileLocalURL, progress: progress, success: { cacheURL in
                success(cacheURL)
            }, failure: { errorMessage in
                let error = NSError(domain: "VideoDownloaderSaveError", code: 1001, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                failure(error)
            })

        }, failure: { error in
            failure(error)
        })
    }
    
    @objc public static func analyzeTiktokShortenedUrl(_ shortenedUrl: String) -> String? {
        if shortenedUrl.isEmpty {
            return "❌ 短链接不能为空，请先输入"
        }
        // 1. 确保 URL 是合法的
        guard let url = URL(string: shortenedUrl), let host = url.host, let scheme = url.scheme else {
            return "❌ 无效的 URL: \(shortenedUrl)"
        }

        // 2. 验证是否符合 TikTok 短链接格式
        let expectedHost = "www.tiktok.com"
        let expectedPathPrefix = "/t"

        guard host == expectedHost, url.path.hasPrefix(expectedPathPrefix) else {
            return "⚠️ 不符合 TikTok 短链接格式: \(shortenedUrl)"
        }
        
        return nil
    }
    
    @objc public static func getActualVideoUrlFromShortenedUrl(
        _ shortenedUrl: String,
        success: @escaping (_ actualVideoUrl: NSString) -> Void,
        failure: @escaping (NSError) -> Void
    ) {
        if let errorMessage = analyzeTiktokShortenedUrl(shortenedUrl) {
            failure(NSError(domain: "VideoParsingError", code: 1001, userInfo: [NSLocalizedDescriptionKey: (errorMessage as NSString)]))
            return
        }
        
        getContentActualUrlAndCookie(tiktokLink: shortenedUrl) { htmlInfo, error in
            if let error = error as? NSError {
                failure(error)
                return
            }
            
            guard let htmlString = htmlInfo?.fullResponse else {
                let error = NSError(domain: "VideoParsingError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Full response is empty or nil"])
                failure(error)
                return
            }
            
            //let fullResponse = "<HTML字符串>"
            var parseError: NSError?
            //let parsedUrl = VideoUrlParser.parseVideoUrlFromHtmlString(fullResponse)
            guard let parsedVideoUrlModel = VideoUrlParser.parseVideoUrlFromHtmlString(htmlString, error: &parseError) else {
                print("解析失败: \(parseError?.localizedDescription ?? "未知错误")")
                failure(parseError!)
                return
            }
            
            let parsedVideoUrl = parsedVideoUrlModel.url
            debugPrint("Tiktok解析成功，地址为: \(parsedVideoUrl)")
            success(parsedVideoUrl)
        }
    }
    
    private static func getContentActualUrlAndCookie(
        tiktokLink: String,
        completion: @escaping (ActualVideoPageUrl?, Error?) -> Void
    ) {
        guard let url = URL(string: tiktokLink) else {
            let error = NSError(domain: "TikTokServiceError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("https://www.tiktok.com", forHTTPHeaderField: "Origin")
        request.setValue("https://www.tiktok.com/", forHTTPHeaderField: "Referer")
        request.setValue("empty", forHTTPHeaderField: "Sec-Fetch-Dest")
        request.setValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
        request.setValue("cross-site", forHTTPHeaderField: "Sec-Fetch-Site")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data, let fullResponse = String(data: data, encoding: .utf8) else {
                let error = NSError(domain: "TikTokServiceError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
                completion(nil, error)
                return
            }
            
            let result = ActualVideoPageUrl(url: url.absoluteString, fullResponse: fullResponse)
            completion(result, nil)
        }
        
        task.resume()
    }
    
    private static func getVideoDataFromActualVideoUrl(
        _ videoUrl: String,
        success: @escaping (_ contentType: VideoContentType?, _ videoData: Data) -> Void,
        failure: @escaping (NSError) -> Void
    ) {
        guard let url = URL(string: videoUrl as String) else {
            let error = NSError(domain: "VideoDownloaderError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            failure(error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Referer": "https://www.tiktok.com/",
            "Sec-Fetch-Dest": "video",
            "Sec-Fetch-Mode": "no-cors",
            "Sec-Fetch-Site": "cross-site",
            "Accept": "*/*",
            "Accept-Encoding": "identity;q=1, *;q=0",
            "Accept-Language": "en-US,en;q=0.9,hu-HU;q=0.8,hu;q=0.7,ro;q=0.6",
            "Connection": "keep-alive",
            "Range": "bytes=0-",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failure(error as NSError)
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "VideoDownloaderError", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                failure(error)
                return
            }
            
            var videoContentType: VideoContentType? = nil
            if let contentTypeString = httpResponse.allHeaderFields["Content-Type"] as? String {
                let contentTypeParts = contentTypeString.split(separator: "/").map(String.init)
                if contentTypeParts.count == 2 {
                    videoContentType = VideoContentType(type: contentTypeParts[0], subtype: contentTypeParts[1])
                }
            }
            
            success(videoContentType, data)
        }
        
        task.resume()
    }
}

@objc(VideoUrlParser)
public class VideoUrlParser: NSObject {
    @objc public static func parseVideoUrlFromHtmlString(_ html: String) -> String? {
        if let range = html.range(of: "\"playAddr\":\"") {
            let subStr = html[range.upperBound...]
            if let endRange = subStr.range(of: "\"") {
                let url = String(subStr[..<endRange.lowerBound])
                return url.replacingOccurrences(of: "\\u002F", with: "/")
            }
        }
        return nil
    }
    
    @objc public static func parseVideoUrlFromHtmlString(_ responseBody: String, error: NSErrorPointer) -> VideoFileUrl? {
        do {
            let html = try throwIfIsCaptchaResponse(responseBody as String)
            
            if let url = tryToParseDownloadLink(html) {
                debugPrint("Parsed download link = \(url)")
                return VideoFileUrl(url: url as NSString)
            }
            
            if let url = tryToParseVideoSrc(html) {
                debugPrint("Parsed video src = \(url)")
                return VideoFileUrl(url: url as NSString)
            }
            
            throw ParsingError.illegalArgument
        } catch let parsingError as ParsingError {
            if error != nil {
                let errorMessage = parsingError == .illegalArgument ? "Couldn't parse URL from HTML" : "Captcha required"
                error?.pointee = NSError(domain: "VideoUrlParserErrorDomain",
                                         code: parsingError.rawValue,
                                         userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            return nil
        } catch {
            return nil
        }
    }
    
    private static func throwIfIsCaptchaResponse(_ html: String) throws -> String {
        if html.count == 0 {
            throw ParsingError.emptyBody
        }
        if html.contains("captcha.js") {
            throw ParsingError.captchaRequired
        }
        
        return html
    }
    
    private static func tryToParseDownloadLink(_ html: String) -> String? {
        guard let range = html.range(of: "\"playAddr\"") else { return nil }
        
        let substring = html[range.upperBound...]
        guard let firstQuote = substring.firstIndex(of: "\"") else { return nil }
        let afterFirstQuote = substring[firstQuote...].dropFirst()
        
        guard let secondQuote = afterFirstQuote.firstIndex(of: "\"") else { return nil }
        let url = String(afterFirstQuote[..<secondQuote])
        
        return urlCharacterReplacements(url)
    }
    
    private static func tryToParseVideoSrc(_ html: String) -> String? {
        guard let videoTagRange = html.range(of: "<video") else { return nil }
        let videoTagSubstring = html[videoTagRange.upperBound...]
        
        guard let endTagRange = videoTagSubstring.range(of: "</video>") else { return nil }
        let videoContent = videoTagSubstring[..<endTagRange.lowerBound]
        
        guard let srcRange = videoContent.range(of: "src") else { return nil }
        let srcSubstring = videoContent[srcRange.upperBound...]
        
        guard let equalsSign = srcSubstring.firstIndex(of: "=") else { return nil }
        let afterEquals = srcSubstring[equalsSign...].dropFirst()
        
        guard let firstQuote = afterEquals.firstIndex(of: "\"") else { return nil }
        let afterFirstQuote = afterEquals[firstQuote...].dropFirst()
        
        guard let secondQuote = afterFirstQuote.firstIndex(of: "\"") else { return nil }
        let url = String(afterFirstQuote[..<secondQuote])
        
        return urlCharacterReplacements(url)
    }
    
    private static func urlCharacterReplacements(_ input: String) -> String {
        let replacements: [String: String] = [
            "\\u002F": "/",
            "\\u0026": "&"
        ]
        
        var result = input
        for (key, value) in replacements {
            result = result.replacingOccurrences(of: key, with: value)
        }
        return result
    }
}

@objc(ParsingError)
public enum ParsingError: Int, Error {
    case emptyBody
    case illegalArgument
    case captchaRequired
}

@objc(ThrowIfIsCaptchaResponse)
public class ThrowIfIsCaptchaResponse: NSObject {

    @objc public func invoke(_ html: NSString, error: NSErrorPointer) {
        if html.length == 0 {
            let err = NSError(domain: "CaptchaError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Empty body"])
            error?.pointee = err
        } else if html.range(of: "captcha.js").location != NSNotFound {
            let err = NSError(domain: "CaptchaError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Contains Captcha keyword"])
            error?.pointee = err
        }
    }
}
//let captchaChecker = ThrowIfIsCaptchaResponse()
//var error: NSError?
//
////            let testHtml = "<html><script src='captcha.js'></script></html>"
//captchaChecker.invoke(testHtml as NSString, error: &error)
//
//if let error = error {
//    print("❌ 检测到验证码: \(error.localizedDescription)")
//} else {
//    print("✅ HTML 通过检测")
//}





import Foundation

@objc(VideoResponse)
public class VideoResponse: NSObject {
    @objc public let mediaType: String?
    @objc public let videoData: Data
    
    @objc public init(mediaType: String?, videoData: Data) {
        self.mediaType = mediaType
        self.videoData = videoData
    }
}


// 定义 ContentType
@objc(VideoContentType)
public class VideoContentType: NSObject {
    @objc public let type: String
    @objc public let subtype: String
    
    @objc public init(type: String, subtype: String) {
        self.type = type
        self.subtype = subtype
    }
}

// 定义 VideoInSavingIntoFile 结构体
@objc(VideoInSavingIntoFile)
public class VideoInSavingIntoFile: NSObject {
    @objc public let id: String
    @objc public let url: String
    @objc public let contentType: VideoContentType?
    @objc public let videoData: Data
    
    @objc public init(id: String, url: String, contentType: VideoContentType?, videoData: Data) {
        self.id = id
        self.url = url
        self.contentType = contentType
        self.videoData = videoData
    }
}
