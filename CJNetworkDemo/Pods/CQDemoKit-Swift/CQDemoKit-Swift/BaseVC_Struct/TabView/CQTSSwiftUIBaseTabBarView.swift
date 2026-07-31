//
//  SwiftUIBaseTabBarView.swift
//  CQDemoKit-Swift
//
//  Created by qian on 2021/3/5.
//

import SwiftUI

/// SwiftUI 版本的 TabBar 视图
/// 类似于 UIKit 的 UITabBarController
@available(iOS 13.0, *)
public struct CQTSSwiftUIBaseTabBarView: View {
    @State private var selectedTab: Int = 0
    let tabBarModels: [CQTSSwiftUITabBarModel]
    
    public init(tabBarModels: [CQTSSwiftUITabBarModel]) {
        self.tabBarModels = tabBarModels
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(tabBarModels.enumerated()), id: \.element.id) { index, model in
                model.view
                    .tabItem {
                        VStack {
                            model.normalImage
                                .renderingMode(.original)
                            Text(model.title)
                        }
                    }
                    .tag(index)
            }
        }
    }
}

// MARK: - Preview
@available(iOS 14.0, *)
struct CQTSSwiftUIBaseTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CQTSSwiftUIBaseTabBarView(tabBarModels: [
            CQTSSwiftUITabBarModel(
                title: "首页",
                normalImage: Image(systemName: "house"),
                view: NavigationView {
                    MySwiftUIBaseHomeView()
                }
            ),
            CQTSSwiftUITabBarModel(
                title: "发现",
                normalImage: Image(systemName: "safari"),
                view: NavigationView {
                    List {
                        Section(header: Text("发现内容")) {
                            NavigationLink(destination: Text("热门内容")) {
                                Text("热门")
                            }
                            NavigationLink(destination: Text("最新内容")) {
                                Text("最新")
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("发现")
                }
            ),
            CQTSSwiftUITabBarModel(
                title: "消息",
                normalImage: Image(systemName: "message"),
                view: NavigationView {
                    List {
                        Section(header: Text("消息列表")) {
                            NavigationLink(destination: Text("系统通知")) {
                                Text("系统通知")
                            }
                            NavigationLink(destination: Text("私信")) {
                                Text("私信")
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("消息")
                }
            ),
            CQTSSwiftUITabBarModel(
                title: "购物",
                normalImage: Image(systemName: "cart"),
                view: NavigationView {
                    List {
                        Section(header: Text("购物车")) {
                            NavigationLink(destination: Text("商品详情")) {
                                Text("商品1")
                            }
                            NavigationLink(destination: Text("订单详情")) {
                                Text("查看订单")
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("购物")
                }
            ),
            CQTSSwiftUITabBarModel(
                title: "我的",
                normalImage: Image(systemName: "person"),
                view: NavigationView {
                    List {
                        Section(header: Text("个人中心")) {
                            NavigationLink(destination: Text("个人资料")) {
                                Text("编辑资料")
                            }
                            NavigationLink(destination: Text("设置页面")) {
                                Text("设置")
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("我的")
                }
            )
        ])
    }
}
