//
//  RecordTimeView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/12/14.
//

import SwiftUI

struct RecordTimeView: View {
    // View用の画面を閉じるdismissハンドラ
    @Environment(\.dismiss) var dismiss
    // ViewModel
    @ObservedObject var viewModel: SettingViewModel
    // テキストの大きさ
    private let fontSize: Font
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        self.fontSize = getFontSize(view: .settingView)
    }
    
    var body: some View {
        ZStack {
            // 設定画面の背景色に合わせる
            Color(red: 242/255, green: 242/255, blue: 247/255).ignoresSafeArea()
            
            VStack {
                // MARK: - 戻るボタン
                HStack {
                    Button{
                        dismiss()
                    } label: {
                        Text("もどる")
                            .font(fontSize)
                    } // Button
                    .padding([.top, .leading])
                    
                    Spacer()
                } // HS
                
                Spacer()
                
                // MARK: - タイトル
                Text("記録する時間の登録")
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                    .padding()
                
                // MARK: - 時間設定
                // 0...23
                Slider(value: $viewModel.recordTime, in: 0...23, step: 1,
                       minimumValueLabel: Text("0時")
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize),
                       maximumValueLabel: Text("23時")
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize),
                       label: { EmptyView() }
                )
                .padding()
                
                // MARK: - 　お知らせ時間表示
                Text("\(Int(viewModel.recordTime))時にお知らせします")
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
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
