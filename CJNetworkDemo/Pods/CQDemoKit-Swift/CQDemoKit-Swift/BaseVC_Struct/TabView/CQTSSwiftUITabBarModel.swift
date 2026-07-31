//
//  CQTSSwiftUITabBarModel.swift
//  CQDemoKit-Swift
//
//  Created by qian on 2021/3/5.
//

import SwiftUI

/// 标签页数据模型
@available(iOS 13.0, *)
public struct CQTSSwiftUITabBarModel: Identifiable {
    public let id = UUID()
    public let title: String
    public let normalImage: Image
    public let selectedImage: Image?
    public let view: AnyView
    
    /// 尾随闭包初始化（@ViewBuilder）
    /// - Parameters:
    ///   - title: 标题
    ///   - normalImage: 未选中图片
    ///   - selectedImage: 选中图片（可选，默认使用normalImage）
    ///   - view: 对应的视图
    public init(title: String, normalImage: Image, selectedImage: Image? = nil, @ViewBuilder view: () -> some View) {
        self.title = title
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.view = AnyView(view())
    }
    
    /// 显式 view 参数初始化
    /// - Parameters:
    ///   - title: 标题
    ///   - normalImage: 未选中图片
    ///   - selectedImage: 选中图片（可选，默认使用normalImage）
    ///   - view: 对应的视图
    public init(title: String, normalImage: Image, selectedImage: Image? = nil, view: any View) {
        self.title = title
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.view = AnyView(view)
    }
}
