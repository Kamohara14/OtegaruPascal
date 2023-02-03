//
//  PastRecordView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/16.
//

import SwiftUI

struct PastRecordView: View {
    // ViewModel
    @ObservedObject var viewModel: RecordViewModel
    
    // Alert用フラグ
    @State private var recordDeleteAlert = false
    
    // テキストの大きさ
    let fontSize: Font
    
    var body: some View {
        VStack {
            HStack {
                // MARK: - 過去の記録
                Text("過去の記録：\(viewModel.recordArray.count)件")
                .foregroundColor(Color("Text_MainColor"))
                .font(fontSize)
                
                Spacer()
                
                // MARK: - 削除ボタン
                Button {
                    // アラート表示
                    self.recordDeleteAlert = true
                    
                } label: {
                    Text("削除")
                        .font(fontSize)
                        .foregroundColor(Color("Text_Red"))
                }
                .alert("", isPresented: $recordDeleteAlert) {
                    Button("削除", role: .destructive) {
                        // 記録の削除
                        viewModel.daleteRecord()
                    }
                } message: {
                    Text("体調記録履歴が全て削除されます。\nよろしいですか?")
                }
            } // HS
            
            // 区切り線
            Divider()
            // MARK: - 記録一覧
            // 記録の有無を確認
            if viewModel.recordArray.count == 0 {
                // 記録がないなら
                Spacer()
                
                Text("記録はありません")
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                
                Spacer()
                
            } else {
                // 記録があるなら、記録一覧を表示
                ScrollView {
                    PastRecordParts(viewModel: viewModel)
                } // Scroll
            }
        } // VS
    }
}

struct PastRecordView_Previews: PreviewProvider {
    static var previews: some View {
        PastRecordView(viewModel: RecordViewModel(), fontSize: getFontSize(view: .homeView))
    }
}

struct PastRecordParts: View {
    // ViewModel
    @ObservedObject var viewModel: RecordViewModel
    // 通知と同じサイズ
    private let fontSize = getFontSize(view: .settingView)
    
    var body: some View {
        ForEach (0..<viewModel.recordArray.count, id: \.self) { num in
            VStack {
                // MARK: - 体調評価
                HStack{
                    Text("評価：\(viewModel.recordArray[num].evaluation)")
                        .foregroundColor(Color("Text_Black"))
                        .font(fontSize)
                    Spacer()
                }
                .padding()
                
                // MARK: - 記録の日付
                HStack{
                    Spacer()
                    Text(viewModel.recordArray[num].date)
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
        } // ForEach
    }
}
