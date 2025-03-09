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
    
//    Data.write(to:) 方法是 同步执行 的，它会一次性将 Data 写入文件，因此无法直接获取 写入进度。但你可以通过 分块写入（chunked writing） 的方式实现写入进度回调。使用流式写入 + 进度回调。我们可以使用 OutputStream 逐步写入数据，并在写入过程中计算进度。
    @objc public static func downloadFileData(
        _ unencryptData: Data,
        fileLocalURL: URL,
        progress: ((_ written: Int64, _ total: Int64, _ percentage: CGFloat) -> Void)? = nil, // 进度回调
        success: @escaping ((_ cacheURL: URL) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        do {
            try ensureDirectoryExists(for: fileLocalURL)  // 确保文件夹存在
            
            guard let outputStream = OutputStream(url: fileLocalURL, append: false) else {
                failure("无法创建文件输出流")
                return
            }
            
            outputStream.open()  // 打开流
            
            let totalBytes = Int64(unencryptData.count)  // 总大小
            var writtenBytes: Int64 = 0  // 已写入大小
            
            let bufferSize = 1024 * 16  // 16KB 分块写入
            var offset = 0
            
            while offset < unencryptData.count {
                let chunkSize = min(bufferSize, unencryptData.count - offset)
                let chunk = unencryptData.subdata(in: offset..<offset + chunkSize) // 取出分块数据
                let bytesWritten = chunk.withUnsafeBytes {
                    outputStream.write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: chunkSize)
                }
                
                if bytesWritten < 0 {
                    failure("写入失败: \(outputStream.streamError?.localizedDescription ?? "未知错误")")
                    outputStream.close()
                    return
                }
                
                writtenBytes += Int64(bytesWritten)
                let percentage = CGFloat(writtenBytes) / CGFloat(totalBytes) // 计算进度
                progress?(writtenBytes, totalBytes, percentage) // 触发进度回调
                
                offset += bytesWritten
            }
            
            outputStream.close()
            success(fileLocalURL) // 成功回调
        } catch {
            failure("文件写入失败: \(error.localizedDescription)")
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
