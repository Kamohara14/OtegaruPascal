//
//  HealthFaceView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/13.
//

import SwiftUI

struct HealthFaceView: View {
    // ViewModel
    @ObservedObject var viewModel: HomeViewModel
    
    // 画面の横幅
    private let width = UIScreen.main.bounds.width
    // iPadかどうか
    private var isPad: Bool
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        // iPadかどうか判定
        if Int(width) >= 700 {
            // iPad
            isPad = true
            
        } else {
            // iPhone
            isPad = false
            
        }
    }
    
    var body: some View {
        ZStack {
            Color("Background_Elements")
            VStack {
                HStack {
                    Spacer()
                    // MARK: - 解説ボタン
                    Button {
                        // 解説を表示する
                        viewModel.isFaceDescriptionDisplayed = true
                        
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(minWidth: 15, maxWidth: 25, minHeight: 15, maxHeight: 25)
                    }
                    // 解説を開いているときはボタンをロックする
                    .allowsHitTesting(!viewModel.isFaceDescriptionDisplayed)
                    
                }
                HStack {
                    // MARK: - 予測された過去の体調
                    Image(viewModel.pastFace.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: width / 5, maxHeight: width / 5)
                    
                    Image("Face_Arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: width / 6, maxHeight: width / 9)
                    
                    // MARK: - 予測された現在の体調
                    Image(viewModel.currentFace.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: width / 4, maxHeight: width / 4)
                    
                    Image("Face_Arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: width / 6, maxHeight: width / 9)
                    
                    // MARK: - 予測された未来の体調
                    Image(viewModel.forecastFace.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: width / 5, maxHeight: width / 5)
                    
                } // HS
                // MARK: - 一言解説
                HStack {
                    Text(viewModel.description.rawValue)
                        .foregroundColor(Color("Text_Black"))
                        .font(.system(size: isPad ? 30 : 15))
                }
            } // VS
            .padding()
            
        } // ZS
        
    } // body
}

struct HealthFaceView_Previews: PreviewProvider {
    static var previews: some View {
        HealthFaceView(viewModel: HomeViewModel())
    }
}
