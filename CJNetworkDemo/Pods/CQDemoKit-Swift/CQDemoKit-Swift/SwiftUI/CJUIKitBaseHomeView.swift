//
//  CJUIKitBaseHomeView.swift
//  CQDemoKit-Swift
//
//  Created by ciyouzen on 2020/2/14.
//  Copyright © 2020 dvlproad. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct CQDMSectionDataModel {
    var theme: String
    var values: [CQDMModuleModel]
    
    public init(theme: String, values: [CQDMModuleModel]) {
        self.theme = theme
        self.values = values
    }
}

@available(iOS 13.0, *)
public struct CQDMModuleModel: Identifiable {
    public var id = UUID()
    var title: String
    var content: String? = nil
    var contentLines: Int? = nil
    var actionBlock: (() -> Void)?
    var classEntry: (() -> AnyView)?
    
    public init(id: UUID = UUID(),
         title: String,
         content: String? = nil,
         contentLines: Int? = nil,
         actionBlock: ( () -> Void)? = nil,
         classEntry: ( () -> AnyView)? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.contentLines = contentLines
        self.actionBlock = actionBlock
        self.classEntry = classEntry
    }
}

@available(iOS 14.0, *)
public struct CJUIKitBaseHomeView: View {
    private var title: String
    private var sectionDataModels: [CQDMSectionDataModel] = []
    
    public init(title: String, sectionDataModels: [CQDMSectionDataModel]) {
        self.title = title
        self.sectionDataModels = sectionDataModels
    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(sectionDataModels, id: \.theme) { sectionDataModel in
                    Section(header: Text(sectionDataModel.theme)) {
                        ForEach(sectionDataModel.values) { moduleModel in
                            if let action = moduleModel.actionBlock {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(moduleModel.title)
                                    if let contentText = moduleModel.content {
                                        let contentLines = moduleModel.contentLines ?? 0
                                        Text(contentText)
                                            .lineLimit(contentLines > 1 ? contentLines : 1)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())  // 扩大点击区域
                                .onTapGesture {
                                    action()
                                }
                            } else {
                                NavigationLink(
                                    destination: self.destinationView(for: moduleModel)
                                ) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(moduleModel.title)
                                        if let contentText = moduleModel.content {
                                            let contentLines = moduleModel.contentLines ?? 0
                                            Text(contentText)
                                                .lineLimit(contentLines > 1 ? contentLines : 1)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 10))
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle(title)
        }
    }
    
    private func destinationView(for moduleModel: CQDMModuleModel) -> some View {
        if let view = moduleModel.classEntry?() {
            return view
        }
        return AnyView(Text("No View Found"))
    }
}
