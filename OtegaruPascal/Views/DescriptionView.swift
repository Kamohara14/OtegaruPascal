//
//  DescriptionView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/10.
//

import SwiftUI

struct DescriptionView: View {
    // ViewModel
    @StateObject private var viewModel = DescriptionViewModel()
    
    // テキストの大きさ
    private let fontSize: Font
    
    init() {
        self.fontSize = getFontSize(view: .homeView)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景色
                Color("Background_NavigationView").ignoresSafeArea(edges: .top)
                Color("Background_App").ignoresSafeArea(edges: .bottom)
                
                VStack {
                    HStack {
                        Text("解説一覧")
                            .foregroundColor(Color("Text_MainColor"))
                            .font(fontSize)
                        Spacer()
                    } // HS
                    .padding()
                    
                    VStack {
                        // 区切り線
                        Divider()
                        
                        // 解説の数だけ繰り返す
                        ForEach (0..<viewModel.descriptionArray.count, id: \.self) { num in
                            // 配列から解説を取り出す
                            let description = viewModel.descriptionArray[num]
                            
                            NavigationLink(destination: DescriptionItemView(
                                title: description.title,
                                text: viewModel.getDescription(type: description.text))) {
                                    HStack {
                                        // 解説のタイトル
                                        Text(description.title)
                                            .foregroundColor(Color("Text_Black"))
                                            .font(fontSize)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color("Text_MainColor"))
                                    } // HS
                                    .padding()
                                    
                                } // NavigationLink
                            
                            // 区切り線
                            Divider()
                            
                        } // ForEach
                    } // VS
                    .background(Color("Background_Elements"))
                    
                    Spacer()
                    
                } // VS
            } // ZS
            .navigationTitle("解説一覧")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            
        } // NavigationView
        // iPadに対応する
        .navigationViewStyle(.stack)
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView()
    }
}
