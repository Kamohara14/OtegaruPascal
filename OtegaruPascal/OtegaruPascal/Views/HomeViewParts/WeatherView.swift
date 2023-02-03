//
//  WeatherView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/13.
//

import SwiftUI

struct WeatherView: View {
    // ViewModel
    @ObservedObject var viewModel: HomeViewModel
    // 天気の詳細を表示するModal用フラグ
    @State private var weatherDetailModal = false
    // 表示する天気は今後の天気かどうか
    private let isForecast: Bool
    // 表示する天気のアイコン
    private let weatherImage: WeatherIcon
    
    init(viewModel: HomeViewModel, isForecast: Bool) {
        self.viewModel = viewModel
        self.isForecast = isForecast
        // 表示するのは現在の天気か今後の天気かどちらか
        if isForecast {
            // 今後の天気
            self.weatherImage = viewModel.weatherForecastImage
            
        } else {
            // 現在の天気
            self.weatherImage = viewModel.weatherImage
        }
    }
    
    var body: some View {
        ZStack {
            // 背景色
            Color("Background_Elements")
            
            Button {
                self.weatherDetailModal.toggle()
                
            } label: {
                Image(systemName: weatherImage.icon.image)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(weatherImage.icon.color1, weatherImage.icon.color2)
                    .frame(minWidth: 60, maxWidth: getFrameSize().w,
                           minHeight: 60, maxHeight: getFrameSize().h)
            } // Button
            .fullScreenCover(isPresented: $weatherDetailModal) {
                WeatherDetailView(viewModel: viewModel, isForecast: isForecast)
                
            } // Modal
            
        } // ZS
        
    } // body
} // WeatherView

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: HomeViewModel(), isForecast: false)
    }
}
