//
//  NotificationView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/07.
//

import SwiftUI

struct NotificationView: View {
    // ViewModel
    @StateObject private var viewModel = NotificationViewModel()
    
    // 通知の更新用
    @ObservedObject var mainViewModel: MainViewModel
    
    // テキストの大きさ
    let fontSize: Font
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        self.fontSize = getFontSize(view: .notificationView)
    }
    
    var body: some View {
        ZStack {
            // 背景色
            Color("Background_NavigationView").ignoresSafeArea(edges: .top)
            Color("Background_App").ignoresSafeArea(edges: .bottom)
            
            VStack {
                // 通知の有無を確認
                if viewModel.notificationArray.count == 0 {
                    // 通知がないなら
                    Text("通知はありません")
                        .foregroundColor(Color("Text_Black"))
                        .font(fontSize)
                    
                } else {
                    // 通知があるなら、通知一覧を表示
                    
                    // 空白を開ける
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    // スクロール
                    ScrollView {
                        // 通知一覧を表示するView
                        NotificationParts(viewModel: viewModel, fontSize: fontSize)
                    }
                }
            } // VS
            .onDisappear {
                // 既読の反映
                mainViewModel.isRead()
            }
            
        }  // ZS
        
    } // body
}

struct NotificationParts: View {
    // ViewModel
    @ObservedObject var viewModel: NotificationViewModel
    
    // テキストの大きさ
    let fontSize: Font
    
    var body: some View {
        ForEach (0..<viewModel.notificationArray.count, id: \.self) { num in
            Button {
                // 既読にする
                viewModel.readNotification(num: num) // データ
                
            } label: {
                VStack {
                    // MARK: - 通知のタイトル
                    HStack{
                        Text(viewModel.notificationArray[num].title)
                            .foregroundColor(Color("Text_Black"))
                            .font(fontSize)
                        Spacer()
                        
                        // 既読かどうか
                        if !viewModel.notificationArray[num].isRead {
                            Image(systemName: "circle.fill")
                                .foregroundColor(Color("Text_Red"))
                        }
                    }
                    .padding()
                    
                    // MARK: - 通知の日付
                    HStack{
                        Spacer()
                        Text(viewModel.notificationArray[num].date)
                            .foregroundColor(Color("Text_Black"))
                            .font(fontSize)
                    }
                    .padding([.bottom, .trailing])
                    
                } // VS
                // MARK: - サイズ調整
                .frame(width: UIScreen.main.bounds.width - 50, height: 100)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color("Background_Elements"))
                )
            } // Button
        } // ForEach
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(mainViewModel: MainViewModel())
    }
}
