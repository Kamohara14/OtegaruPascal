//
//  WeatherDetailView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2023/01/18.
//

import SwiftUI

struct WeatherDetailView: View {
    // View用の画面を閉じるdismissハンドラ
    @Environment(\.dismiss) var dismiss
    // ViewModel
    @ObservedObject var viewModel: HomeViewModel
    // テキストの大きさ
    private let fontSize: Font
    // 表示する天気のアイコン
    private let weatherImage: WeatherIcon
    // 表示する天気は今後の天気かどうか
    private let isForecast: Bool
    
    init(viewModel: HomeViewModel, isForecast: Bool) {
        self.fontSize = getFontSize(view: .homeView)
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
            Color("Background_Elements").ignoresSafeArea()
            
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
                
                // MARK: - 天気アイコン
                Image(systemName: weatherImage.icon.image)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(weatherImage.icon.color1, weatherImage.icon.color2)
                    .frame(minWidth: 60, maxWidth: getFrameSize().w,
                           minHeight: 60, maxHeight: getFrameSize().h)
                    .padding()
                
                // 区切り線
                Divider()
                
                // MARK: - 詳細
                detailView(viewModel: viewModel, isForecast: isForecast)
                
                Spacer()
            } // VS
        } // ZS
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(viewModel: HomeViewModel(), isForecast: false)
    }
}

// MARK: - 詳細
struct detailView: View {
    // テキストの大きさ
    private let fontSize: Font
    // 表示する詳細項目
    private let description: String // 天気の解説
    private let temp: String // 気温
    private let humidity: String // 湿度
    private let uvi: String // UV指数
    private let clouds: String // 曇り度
    private let windSpeed: String // 風速
    private let pop: String // 降水確率
    
    init(viewModel: HomeViewModel, isForecast: Bool) {
        self.fontSize = getFontSize(view: .homeView)
        // 表示するのは現在の天気か今後の天気かどちらか
        if isForecast {
            // 今後の天気の詳細
            self.description = viewModel.weatherForecastDescription
            self.temp = viewModel.forecastTemp
            self.humidity = viewModel.forecastHumidity
            self.uvi = viewModel.forecastUvi
            self.clouds = viewModel.forecastClouds
            self.windSpeed = viewModel.forecastWindSpeed
            self.pop = viewModel.forecastPop
            
        } else {
            // 現在の天気の詳細
            self.description = viewModel.weatherDescription
            self.temp = viewModel.temp
            self.humidity = viewModel.humidity
            self.uvi = viewModel.uvi
            self.clouds = viewModel.clouds
            self.windSpeed = viewModel.windSpeed
            self.pop = viewModel.pop
            
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(description)
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                    .padding()
                Text(uvi)
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                    .padding()
                Text(windSpeed)
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                    .padding()
                
            } // HS
            
            VStack(alignment: .leading) {
                Text(temp)
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                    .padding()
                Text(clouds)
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                    .padding()
                Text(pop)
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                    .padding()
            } // VS
            
            Text(humidity)
                .foregroundColor(Color("Text_Black"))
                .font(fontSize)
                .padding()
            
        } // HS
    }
}
