//
//  DrugNotificationView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/13.
//

import SwiftUI

struct DrugNotificationView: View {
    // ViewModel
    @ObservedObject var viewModel: HomeViewModel
    // テキストの大きさ
    private let fontSize: Font
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.fontSize = getFontSize(view: .settingView)
    }
    
    var body: some View {
        ZStack {
            // 背景色
            Color("Background_Elements")
            VStack {
                Spacer()
                
                // MARK: - お薬通知のタイトル
                HStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color("DrugNotification_Title"))
                        .frame(minHeight: 30, maxHeight: 50)
                        .overlay(
                            Text(viewModel.drugTitle)
                                .foregroundColor(Color("Text_Black"))
                                .font(fontSize)
                        )
                    
                    Spacer()
                } // Title
                
                HStack {
                    Spacer()
                    
                    // MARK: - 飲んだボタン
                    Button {
                        // 通知を消す処理
                        viewModel.isDrugNotificationDisplayed = false
                        
                    } label: {
                        Text(" 飲みました ")
                            .foregroundColor(Color("Text_White"))
                            .font(fontSize)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20)
                                .fill(Color("Button_Ok"))
                            )
                    } // Button
                    // 解説を開いているときはボタンをロックする
                    .allowsHitTesting(!viewModel.isFaceDescriptionDisplayed)
                    
                    Spacer()
                } // HS
                .frame(minHeight: 50)
                
                Spacer()
            } // VS
        } // ZS
        
    } // body
}


struct DrugNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        DrugNotificationView(viewModel: HomeViewModel())
    }
}
