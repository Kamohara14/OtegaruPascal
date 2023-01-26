//
//  InputRecordView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/16.
//

import SwiftUI

struct InputRecordView: View {
    // ViewModel
    @ObservedObject var viewModel: RecordViewModel
    
    // テキストの大きさ
    let fontSize: Font
    
    var body: some View {
        VStack {
            VStack {
                // MARK: - 体調評価
                HStack {
                    Text("体調評価")
                        .foregroundColor(Color("Text_MainColor"))
                        .font(fontSize)
                    Spacer()
                } // HS
                .padding([.top, .leading, .trailing])
                
                HStack(spacing: 5) {
                    VStack {
                        Image("Face_Worst")
                            .resizable()
                            .scaledToFit()
                            .padding()
                        
                        Button {
                            // 評価：とても良くない
                            viewModel.selectedButton(buttonNum: .Button1)
                            
                        } label: {
                            Text("悪い")
                                .foregroundColor(viewModel.evaluationButton.3.0)
                                .font(fontSize)
                                .padding(.horizontal, 20)
                                .background(viewModel.evaluationButton.3.1)
                        } // Button_1
                        .cornerRadius(3)
                        
                    } // VS
                    
                    VStack {
                        Image("Face_Bad")
                            .resizable()
                            .scaledToFit()
                            .padding()
                        
                        Button {
                            // 評価：良くない
                            viewModel.selectedButton(buttonNum: .Button2)
                            
                        } label: {
                            Text("やや悪い")
                                .foregroundColor(viewModel.evaluationButton.2.0)
                                .font(fontSize)
                                .padding(.horizontal, 5)
                                .background(viewModel.evaluationButton.2.1)
                        } // Button_2
                        .cornerRadius(3)
                        
                    } // VS
                    
                    VStack {
                        Image("Face_Normal")
                            .resizable()
                            .scaledToFit()
                            .padding()
                        
                        Button {
                            // 評価：通常
                            viewModel.selectedButton(buttonNum: .Button3)
                            
                        } label: {
                            Text("通常通り")
                                .foregroundColor(viewModel.evaluationButton.1.0)
                                .font(fontSize)
                                .padding(.horizontal, 5)
                                .background(viewModel.evaluationButton.1.1)
                        } // Button_3
                        .cornerRadius(3)
                        
                    } // VS
                    
                    VStack {
                        Image("Face_Good")
                            .resizable()
                            .scaledToFit()
                            .padding()
                        
                        Button {
                            // 評価：良好
                            viewModel.selectedButton(buttonNum: .Button4)
                            
                        } label: {
                            Text("良い")
                                .foregroundColor(viewModel.evaluationButton.0.0)
                                .font(fontSize)
                                .padding(.horizontal, 20)
                                .background(viewModel.evaluationButton.0.1)
                        } // Button_4
                        .cornerRadius(3)
                        
                    } // VS
                    
                } // HS
                .padding([.leading, .bottom, .trailing], 4)
                
            } // VS
            .padding(.bottom)
            .background(RoundedRectangle(cornerRadius: 30)
                .fill(Color("Background_Elements")))
            
            Spacer()
            
            // MARK: - 記録ボタン
            VStack {
                if viewModel.isSave {
                    Button {
                        // 記録する
                        viewModel.addRecord()
                        // 記録ボタンを非表示に
                        viewModel.isSave = false
                        
                    } label: {
                        Text(" 記録する ")
                            .foregroundColor(Color("Text_White"))
                            .font(fontSize)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Button_Ok"))
                            )
                    } // Button
                }
            } // VS
            
            Spacer()
            
        } // VS
    }
}

struct InputRecordView_Previews: PreviewProvider {
    static var previews: some View {
        InputRecordView(viewModel: RecordViewModel(), fontSize: getFontSize(view: .homeView))
    }
}
