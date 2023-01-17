//
//  RecordView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/10.
//

import SwiftUI

struct RecordView: View {
    // ViewModel
    @StateObject private var viewModel = RecordViewModel()
    
    // テキストの大きさ
    let fontSize: Font
    
    init() {
        self.fontSize = getFontSize(view: .homeView)
    }
    
    var body: some View {
        ZStack {
            // 背景色
            Color("Background_NavigationView").ignoresSafeArea(edges: .top)
            Color("Background_App").ignoresSafeArea(edges: .bottom)
            
            VStack {
                // MARK: - 記録の入力
                HStack {
                Text("体調の記録")
                    .foregroundColor(Color("Text_MainColor"))
                    .font(fontSize)
                    
                    Spacer()
                } // HS
                
                InputRecordView(viewModel: viewModel, fontSize: fontSize)
                
                // MARK: - 過去の記録
                PastRecordView(viewModel: viewModel, fontSize: fontSize)
                
            } // VS
            .padding()
            
        } // ZS
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
