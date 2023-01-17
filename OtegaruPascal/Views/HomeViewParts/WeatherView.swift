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
    
    var body: some View {
        ZStack {
            // 背景色
            Color("Background_Elements")
            Image(systemName: viewModel.weatherImage.icon.0)
                .resizable()
                .scaledToFit()
                .foregroundStyle(viewModel.weatherImage.icon.1, viewModel.weatherImage.icon.2)
                .frame(minWidth: 60, maxWidth: getFrameSize().w,
                       minHeight: 60, maxHeight: getFrameSize().h)
            
        } // ZS
        
    } // body
} // WeatherView

struct WeatherForecastView: View {
    // ViewModel
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            // 背景色
            Color("Background_Elements")
            Image(systemName:viewModel.weatherForecastImage.icon.0)
                .resizable()
                .scaledToFit()
                .foregroundStyle(viewModel.weatherForecastImage.icon.1,
                                 viewModel.weatherForecastImage.icon.2)
                .frame(minWidth: 60, maxWidth: getFrameSize().w,
                       minHeight: 60, maxHeight: getFrameSize().h)
            
        } // ZS
        
    } // body
} // WeatherForecastView

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: HomeViewModel())
        WeatherForecastView(viewModel: HomeViewModel())
    }
}
