//
//  CQTSSwiftUIBaseHomeView.swift
//  CQDemoKit-Swift
//
//  Created by ciyouzen on 2020/2/14.
//  Copyright © 2020 dvlproad. All rights reserved.
//

import SwiftUI

// MARK: - SwiftUI 专用模型（与 ObjC 的 CQDMSectionDataModel / CQDMModuleModel 同名但独立），解决：在 swiftui 里 values 如果是 ObjC 的 NSMutableArray，不能直接用于 ForEach ，需要多一层转换的问题。

@available(iOS 13.0, *)
public struct CQDMSwiftUISectionDataModel {
    public var theme: String
    public var values: [CQDMSwiftUIModuleModel]
    
    public init(theme: String, values: [CQDMSwiftUIModuleModel]) {
        self.theme = theme
        self.values = values
    }
}

@available(iOS 13.0, *)
public struct CQDMSwiftUIModuleModel: Identifiable {
    public var id = UUID()
    public var title: String
    public var content: String? = nil
    public var contentLines: Int? = nil
    public var actionBlock: (() -> Void)?
    public var viewGetterHandle: (() -> AnyView)?
    
    public init(
         title: String,
         content: String? = nil,
         contentLines: Int? = nil,
         actionBlock: (() -> Void)? = nil,
         viewGetterHandle: (() -> AnyView)? = nil
    ) {
        self.title = title
        self.content = content
        self.contentLines = contentLines
        self.actionBlock = actionBlock
        self.viewGetterHandle = viewGetterHandle
    }
}
