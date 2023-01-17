//
//  RecordTimeView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/12/14.
//

import SwiftUI

struct RecordTimeView: View {
    // ViewModel
    @ObservedObject var viewModel: SettingViewModel
    // View用の画面を閉じるdismissハンドラ
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                // MARK: - 戻るボタン
                HStack {
                Button("もどる") {
                    dismiss()
                } // Button
                .padding([.top, .leading])
                    
                    Spacer()
                }
                
                // MARK: - タイトル
                Text("記録する時間の登録")
                    .foregroundColor(Color("Text_Black"))
                    .padding()
                
                Spacer()

                // MARK: - 　お知らせ時間表示
                Text("\(Int(viewModel.recordTime))時にお知らせします")
                    .foregroundColor(Color("Text_Black"))
                    .padding()
                
                // MARK: - 時間設定
                // 0...23
                Slider(value: $viewModel.recordTime, in: 0...23, step: 1,
                       minimumValueLabel: Text("0時").foregroundColor(Color("Text_Black")),
                       maximumValueLabel: Text("23時").foregroundColor(Color("Text_Black")),
                       label: { EmptyView() }
                )
                .padding()
                
                Spacer()
                Spacer()
                
            } // VS
        } // ZS
    }
}

struct RecordTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RecordTimeView(viewModel: SettingViewModel())
    }
}
