//
//  HealthFaceDescriptionView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

struct HealthFaceDescriptionView: View {
    // 表示するView
    @Binding var isPresented: Bool
    
    // テキストの大きさ
    private let fontSize: Font

    init(isPresented: Binding<Bool>) {
        // Bindingであるため「 _ 」が必要
        self._isPresented = isPresented
        self.fontSize = getFontSize(view: .settingView)
    }
    
    var body: some View {
        ZStack {
            // 背景色
            Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.97)
            
            VStack {
                // 通知を閉じるためのボタン
                HStack {
                    // 閉じるボタン
                    Button {
                        // 解説を閉じる
                        isPresented = false
                        
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()
                } // HS
                
                // 区切り線
                Divider()
                
                // 体調は良好
                HStack {
                    Image("Face_Good")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 80, minHeight: 80)
                    
                    Text("・・・良好")
                        .foregroundColor(Color("Text_Black"))
                        .font(fontSize)
                        .fontWeight(.medium)
                }
                
                // 体調は通常通り
                HStack {
                    Image("Face_Normal")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 80, minHeight: 80)
                    
                    Text("・・・通常")
                        .foregroundColor(Color("Text_Black"))
                        .font(fontSize)
                        .fontWeight(.medium)
                }
                
                // 体調に注意
                HStack {
                    Image("Face_Bad")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 80, minHeight: 80)
                    
                    Text("・・・注意")
                        .foregroundColor(Color("Text_Black"))
                        .font(fontSize)
                        .fontWeight(.medium)
                }
                
                // 体調が悪くなる恐れあり
                HStack {
                    Image("Face_Worst")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 80, minHeight: 80)
                    
                    Text("・・・警告")
                        .foregroundColor(Color("Text_Black"))
                        .font(fontSize)
                        .fontWeight(.medium)
                }
                
                // 区切り線
                Divider()
                
            } // VS
            .padding()
            
        } // ZS
        // サイズ調整
        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 300)
        
    } // body
}

struct HealthFaceDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        HealthFaceDescriptionView(isPresented: .constant(false))
    }
}
