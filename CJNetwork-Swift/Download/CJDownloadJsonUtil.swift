//
//  CJDownloadJsonUtil.swift
//  CJNetwork-Swift
//
//  Created by ciyouzen on 2020/2/25.
//  Copyright © 2020年 dvlproad. All rights reserved.
//

import Foundation

public struct CJDownloadJsonUtil {
    public static func getZipNameWithoutExtension(zipPathOrUrl: String) -> String {
        var zipName: String
        if let jsonZipNetworkURL = URL(string: zipPathOrUrl) {
            zipName = jsonZipNetworkURL.lastPathComponent
        } else {
            zipName = "unknown_jsonZipName.zip"
        }
        
        let zipNameWithoutExtension: String = (zipName as NSString).deletingPathExtension
        return zipNameWithoutExtension
    }
    
    
    public static func downloadAndParsingJsonZipUrl<TModel: Codable>(
        _ jsonZipNetworkUrl: String,
        enableCache: Bool,  // 是否允许缓存，false则每次都重新下载zip并解压和解析
        zipDataDecryptHandle: ((_ serviceData: Data) -> (Data?))? = nil,
        saveToDirectoryURL: URL,    // zip和unzip都存在这个目录下
        saveWithZipName: String?,       // 解压前把zip以什么名字保存到本地（为nil时候使用后台自身文件名）
        upzipFileName: String,          // 解压之后得到的文件名（请确保本值为解压之后的实际名字）
        zipProgressHandler: ((_ progressValue: CGFloat) -> Void)? = nil,
        success: @escaping ((TModel) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        let jsonFileLocalURL = saveToDirectoryURL.appendingPathComponent(upzipFileName)
        
        if enableCache, FileManager.default.fileExists(atPath: jsonFileLocalURL.path) {
            parsingJsonFileLocalURL(jsonFileLocalURL, success: { (dataModel: TModel) in
                success(dataModel)
            },failure: { errorMessage in
                failure(errorMessage)
            })
        } else {
            CJDownloadUtil.downloadZipUrl(jsonZipNetworkUrl, zipDataDecryptHandle: zipDataDecryptHandle, saveToDirectoryURL: saveToDirectoryURL, saveWithZipName: saveWithZipName, upzipFileName: upzipFileName, zipProgressHandler: zipProgressHandler, success: { unzipLocalURL in
                parsingJsonFileLocalURL(unzipLocalURL, success: { (dataModel: TModel) in
                    success(dataModel)
                },failure: { errorMessage in
                    failure(errorMessage)
                })
            }, failure: failure)
        }
    }
    
    
    
    /// 从 jsonFileURL 文件中读取 json 数据，并转为模型
    public static func parsingJsonFileLocalURL<TModel: Codable>(
        _ jsonFileLocalURL: URL,
        success: @escaping ((TModel) -> Void),
        failure: ((_ errorMessage: String) -> Void)
    ) {
        guard FileManager.default.fileExists(atPath: jsonFileLocalURL.path) else {
            failure("JSON文件不存在，请检查所拼接的路径:\(jsonFileLocalURL)")
            return
        }
        
        do {
            // 读取 JSON 文件中的数据为 Data
            let jsonData = try Data(contentsOf: jsonFileLocalURL)
            
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(TModel.self, from: jsonData)
                success(model)
            } catch {
                failure("JSON数据解析失败:\(jsonFileLocalURL) \(error.localizedDescription)")
            }
            
        } catch {
            failure("JSON文件读取失败:\(error.localizedDescription)")
        }
    }
}
