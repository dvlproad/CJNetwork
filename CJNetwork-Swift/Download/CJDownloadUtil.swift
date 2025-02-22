//
//  CJDownloadUtil.swift
//  CJNetwork-Swift
//
//  Created by ciyouzen on 2020/2/25.
//  Copyright © 2020年 dvlproad. All rights reserved.
//
//  可 ①下载普通文件 或者 ②下载zip文件并解压出内部文件

import Foundation
import SSZipArchive

@objc public class CJDownloadUtil: NSObject {
    /// 下载zip文件并解压出内部文件
    @objc public static func downloadZipUrl(
        _ zipNetworkUrl: String,
        zipDataDecryptHandle: ((_ serviceData: Data) -> (Data?))? = nil,
        saveToDirectoryURL: URL,
        saveWithZipName: String?,       // 解压前把zip以什么名字保存到本地（为nil时候使用后台自身文件名）
        upzipFileName: String,          // 解压之后得到的文件名（请确保本值为解压之后的实际名字）
        zipProgressHandler: ((_ progressValue: CGFloat) -> Void)? = nil,
        success: @escaping ((_ unzipLocalURL: URL) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
//        let unzipLocalURL = toDirectoryURL.appendingPathComponent(upzipFileName)

        var zipName: String
        if let zipSaveWithName = saveWithZipName, zipSaveWithName.count > 0 {
            zipName = zipSaveWithName
        } else {
            if let zipNetworkURL = URL(string: zipNetworkUrl) {
                zipName = zipNetworkURL.lastPathComponent
            } else {
                zipName = "unknown_jsonZipName.zip"
            }
        }

        downloadFileUrl(zipNetworkUrl, fileDataDecryptHandle: zipDataDecryptHandle, saveToDirectoryURL: saveToDirectoryURL, saveWithFileName: zipName, success: { zipLocalURL in
            let unzipLocalURL = zipLocalURL.deletingLastPathComponent().appendingPathComponent(upzipFileName)
            SSZipArchive.unzipFile(atPath: zipLocalURL.path, toDestination: saveToDirectoryURL.path, progressHandler: { (entry, ipInfo, entryNumber, total) in
                zipProgressHandler?(CGFloat(total))
            }, completionHandler: { (path, succeeded, error) in
                if succeeded == false {
                    failure("解压文件失败:\(zipLocalURL.path), \(error?.localizedDescription ?? "")")
                } else {
                    //debugPrint("解压出来的文件位于:\(path)")
                    success(unzipLocalURL)
                }
            })
        }, failure: { errorMessage in
            failure(errorMessage)
        })
    }
    
    /// 下载普通文件
    @objc public static func downloadFileUrl(
        _ fileNetworkUrl: String,
        fileDataDecryptHandle: ((_ serviceData: Data) -> (Data?))? = nil,
        saveToDirectoryURL: URL,
        saveWithFileName: String,
        success: @escaping ((_ cacheURL: URL) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        guard let fileNetworkURL = URL(string: fileNetworkUrl) else {
            failure("要下载的文件地址无效，请检查:\(fileNetworkUrl)")
            return
        }
        
        guard let scheme = saveToDirectoryURL.scheme, scheme == "file" else {
            failure("saveToDirectoryURL 不是一个有效的 file:// URL ，会导致之后写入失败。请检查是否是用 [NSURL fileURLWithPath:directoryUrl];")
            return
        }
        
        // 下载部分
        let downloadTask = URLSession.shared.downloadTask(with: fileNetworkURL, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) in
            guard let URL = location, let response = response, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                failure("下载文件失败:\(error?.localizedDescription ?? "Unknown error") ,想要下载的文件\(fileNetworkUrl)")
                return
            }
            
            do {
                let serviceData: Data = try Data(contentsOf: URL)
                
                var unencryptData: Data?
                if let decryptBlock = fileDataDecryptHandle {
                    unencryptData = decryptBlock(serviceData)
                    if unencryptData == nil {
                        failure("加密的文件下载后，解密失败，请检查:\(URL)")
                        return
                    }
                    
                } else {
                    unencryptData = serviceData
                }
                
                
                let cacheURL = saveToDirectoryURL.appendingPathComponent(saveWithFileName)
                do {
                    try ensureDirectoryExists(for: cacheURL)  // 确保文件夹存在
                    try unencryptData?.write(to: cacheURL)  // 写入到缓存
                    success(cacheURL)  // 成功回调
                } catch {
                    failure("文件下载后，写入/保存失败:\(error) 想要写入的位置:\(cacheURL)")  // 写入失败
                }
                
                
            } catch {
                failure("文件下载后，读取失败，请检查:\(URL)")
            }
        })
        downloadTask.resume()
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
}
