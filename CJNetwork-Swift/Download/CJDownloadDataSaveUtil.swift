//
//  CJDownloadUtil.swift
//  CJNetwork-Swift
//
//  Created by ciyouzen on 2020/2/25.
//  Copyright © 2020年 dvlproad. All rights reserved.
//
//  （本地/网络）数据的保存

import Foundation

@objc public class CJDownloadDataSaveUtil: NSObject {
    /// 下载普通文件
    @objc public static func downloadFileData(
        _ unencryptData: Data,
        fileLocalURL: URL,
        success: @escaping ((_ cacheURL: URL) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        do {
            try ensureDirectoryExists(for: fileLocalURL)  // 确保文件夹存在
            try unencryptData.write(to: fileLocalURL)  // 写入到缓存
            success(fileLocalURL)  // 成功回调
        } catch {
            failure("文件下载后，写入/保存失败:\(error) 想要写入的位置:\(fileLocalURL)")  // 写入失败
        }
    }
    
    // 确保文件夹存在
    @objc public static func ensureDirectoryExists(for fileLocalURL: URL) throws {
        let directoryURL = fileLocalURL.deletingLastPathComponent()  // 获取目录路径
        let fileManager = FileManager.default
        
        // 检查目录是否存在
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                // 如果目录不存在，则创建目录
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                // 目录创建失败，抛出错误
                throw error
            }
        }
    }
    

    @objc public static func generateVideoFileName(actualVideoUrl: String, fileExtension: String) -> String {
        // 获取当前时间
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = dateFormatter.string(from: Date())

        // 获取 URL 最后一部分
        var fileNameFromUrl = actualVideoUrl.components(separatedBy: "/").last ?? "unknown"
        // 限制文件名长度，保留最后 maxFileNameLength 个字符。文件名如果太长可能会导致存储或系统访问问题。
        let maxFileNameLength = 20
        if fileNameFromUrl.count > maxFileNameLength {
            fileNameFromUrl = String(fileNameFromUrl.suffix(maxFileNameLength))
        }
        
        
        // 确保文件后缀
        let finalFileName: String
        if fileNameFromUrl.lowercased().hasSuffix(".\(fileExtension)") {
            finalFileName = fileNameFromUrl
        } else {
            finalFileName = "\(fileNameFromUrl).\(fileExtension)"
        }

        // 拼接最终文件名
        var lastFileName = "\(timestamp) \(finalFileName)"
        
        // 限制文件名长度，保留最后 maxFileNameLength 个字符。文件名如果太长可能会导致存储或系统访问问题。
//        let maxFileNameLength = 20
//        if lastFileName.count > maxFileNameLength {
//            lastFileName = String(lastFileName.suffix(maxFileNameLength))
//        }
        
        return lastFileName
    }
}
