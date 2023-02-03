//
//  DescriptionItemView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2023/01/11.
//

import SwiftUI

struct DescriptionItemView: View {
    // 解説
    let title: String
    let text: String
    
    // テキストの大きさ
    private let fontSize: Font
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
        self.fontSize = getFontSize(view: .homeView)
    }
    
    var body: some View {
        ZStack {
            // 背景色
            Color("Background_NavigationView").ignoresSafeArea(edges: .top)
            Color("Background_App").ignoresSafeArea(edges: .bottom)
            
            VStack {
                // MARK: - 解説内容のタイトル
                HStack {
                    Text(title)
                        .foregroundColor(Color("Text_MainColor"))
                        .font(fontSize)
                    Spacer()
                } // HS
                .padding()
                
                // MARK: - 解説内容
                ScrollView {
                    VStack {
                        Text(text)
                            .foregroundColor(Color("Text_Black"))
                            .font(fontSize)
                    } // VS
                } // Scroll
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color("Background_Elements"))
                )
            } // VS
            
        } // ZS
    }
}

struct DescriptionItemView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionItemView(title: "天気と気圧の関係性について",
                            text: DescriptionViewModel().getDescription(type: .weatherAndPressure))
    }
}
