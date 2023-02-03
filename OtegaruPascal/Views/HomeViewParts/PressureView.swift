//
//  PressureView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/13.
//

import SwiftUI

struct PressureView: View {
    // ViewModel
    @ObservedObject var viewModel: HomeViewModel
    // iPadかどうか
    private var isPad: Bool
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        // iPadかどうか判定
        if Int(UIScreen.main.bounds.width) >= 700 {
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
            HStack {
                Spacer()
                // MARK: - 現在の気圧の数値
                Text(viewModel.pressureString)
                    .foregroundColor(Color("Text_Black"))
                    .font(.system(size: isPad ? 80 : 40))
                    .padding()
                
                // MARK: - 現在の気圧の傾向(上昇・下降・変化なし)
                Image(systemName: viewModel.pressureArrow.type.rawValue)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(viewModel.pressureArrow.color)
                    .frame(maxWidth: isPad ? 80 : 50, maxHeight: isPad ? 80 : 50)
                    
                Spacer()
            }
        } // ZS
        
    } // body
}

struct PressureView_Previews: PreviewProvider {
    static var previews: some View {
        PressureView(viewModel: HomeViewModel())
    }
}
