//
//  CQTSSwiftUIBaseHomeView.swift
//  CQDemoKit-Swift
//
//  Created by ciyouzen on 2020/2/14.
//  Copyright © 2020 dvlproad. All rights reserved.
//

import SwiftUI

// MARK: - CQTSSwiftUIBaseHomeView

@available(iOS 14.0, *)  // .navigationTitle(title) // 需要iOS14
public struct CQTSSwiftUIBaseHomeView: View {
    private var title: String
    private var sectionDataModels: [CQDMSwiftUISectionDataModel] = []
    
    public init(title: String, sectionDataModels: [CQDMSwiftUISectionDataModel]) {
        self.title = title
        self.sectionDataModels = sectionDataModels
    }

    public var body: some View {
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
        .listStyle(InsetGroupedListStyle())
        .modifier(NavigationTitleModifier(title: title)) // 可选标题
    }
    
    private func destinationView(for moduleModel: CQDMSwiftUIModuleModel) -> some View {
        if let view = moduleModel.viewGetterHandle?() {
            return view
        }
        return AnyView(Text("No View Found"))
    }
}

// 自定义 Modifier
@available(iOS 14.0, *)
struct NavigationTitleModifier: ViewModifier {
    let title: String?
    
    func body(content: Content) -> some View {
        if let title = title {
            content.navigationTitle(title)
        } else {
            content
        }
    }
}

// MARK: - Preview
/*
@available(iOS 14.0, *)
struct CQTSSwiftUIBaseHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MySwiftUIBaseHomeView()
        }
    }
}
*/
@available(iOS 14.0, *)
#Preview {
    NavigationView {
        MySwiftUIBaseHomeView()
    }
}

@available(iOS 14.0, *)
struct MySwiftUIBaseHomeView: View {
    var body: some View {
        CQTSSwiftUIBaseHomeView(
            title: "首页",
            sectionDataModels: [
                CQDMSwiftUISectionDataModel(
                    theme: "功能列表",
                    values: [
                        CQDMSwiftUIModuleModel(
                            title: "跳转到详情页面",
                            content: "使用 viewGetterHandle 点击后跳转到 NavigationLink",
                            viewGetterHandle: {
                                AnyView(Text("详情页面"))
                            }
                        ),
                        CQDMSwiftUIModuleModel(
                            title: "点击执行动作",
                            content: "使用 actionBlock 点击后直接执行闭包",
                            actionBlock: {
                                print("点击了 actionBlock")
                            }
                        )
                    ]
                ),
                CQDMSwiftUISectionDataModel(
                    theme: "更多功能",
                    values: [
                        CQDMSwiftUIModuleModel(
                            title: "设置",
                            viewGetterHandle: {
                                AnyView(Text("设置页面"))
                            }
                        ),
                        CQDMSwiftUIModuleModel(
                            title: "关于",
                            content: "版本 1.0.0",
                            viewGetterHandle: {
                                AnyView(Text("关于页面"))
                            }
                        )
                    ]
                )
            ]
        )
    }
}
