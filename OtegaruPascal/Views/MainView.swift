//
//  MainView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/09/30.
//

import SwiftUI

struct MainView: View {
    // ViewModel
    @StateObject private var viewModel = MainViewModel()
    // 初回起動かどうかを判断する
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    
    // View変更用のイニシャライザ
    init() {
        // NavigationView
        // 背景の色
        UINavigationBar.appearance().backgroundColor = UIColor(named: "Background_NavigationView")
        // backの色
        UINavigationBar.appearance().tintColor = .white
        
        // TabView
        // TabViewの背景色の設定
        UITabBar.appearance().backgroundColor
        = UIColor(red: 231/255, green: 253/255, blue: 231/255, alpha: 1)
        
        // 非選択のTabの色
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "Tab_NotSelected")
        
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    tabView()
                    
                } // VS
                
            } // ZS
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: - アプリロゴ
                ToolbarItem(placement: .navigationBarLeading) {
                    // Imageでは表示されないため押せないボタンとして表示する
                    Button {} label: {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 74, height: 45)
                    }.disabled(true)
                    
                } // ToolbarItem
                
                // 通知・設定ボタン
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // MARK: - 通知ボタン
                    Button {} label: {
                        NavigationLink(destination: NotificationView(mainViewModel: viewModel)) {
                            if viewModel.isAllRead.0 {
                                Image(systemName: "bell.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height:30)
                                    .foregroundColor(.white)
                                
                            } else {
                                Image(systemName: "bell.badge.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.red, .white)
                                
                            }
                            
                        } // NavigationLink
                    } // 通知ボタン
                    
                    // MARK: - 設定ボタン
                    Button {} label: {
                        NavigationLink(destination: SettingView(mainViewModel: viewModel)) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        } // NavigationLink
                    } // 設定ボタン
                    .padding(10)
                } // ToolbarItemGroup
            } // toolbar
            .alert(isPresented: $isFirstLaunch) {
                Alert(title: Text("通知許可について"),
                      message: Text("このアプリでは、以下の場合通知を使用します。\n\n・体調不良が予想された時\n・体調を記録する時間になった時\n\n「了解」を押すと通知許可の画面が表示されます。"),
                      dismissButton: .default(Text("了解"), action: {
                    // 通知の許可を取る
                    viewModel.permitNotification()
                }))
            }
            
        } // NavigationView
        // iPadに対応する
        .navigationViewStyle(.stack)
        
    } // body
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct tabView: View {
    // ホーム画面が初期表示 (0.ホーム画面 1.記録画面 2.解説画面)
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DescriptionView()
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("解説一覧")
                }.tag(2)
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("ホーム")
                }.tag(0)
            
            RecordView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("体調記録")
                }.tag(1)
            
        } // Tab
        // 選択しているタブの色
        .accentColor(Color("Tab_Selected"))
    }
} // footer
