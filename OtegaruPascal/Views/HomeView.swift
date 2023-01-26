//
//  HomeView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/11.
//

import SwiftUI

struct HomeView: View {
    // ViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    // テキストの大きさ
    private let fontSize: Font
    
    init() {
        self.fontSize = getFontSize(view: .homeView)
    }
    
    var body: some View {
        ZStack {
            // 背景色
            Color("Background_NavigationView").ignoresSafeArea(edges: .top)
            Color("Background_App").ignoresSafeArea(edges: .bottom)
            
            VStack {
                // MARK: - お薬の画面通知
                if viewModel.isDrugNotificationDisplayed {
                    DrugNotificationView(viewModel: viewModel)
                        .frame(minHeight: 90, maxHeight: 140)
                        .cornerRadius(30)
                }
                
                Spacer()
                
                // MARK: - 天気予報
                HStack {
                    // 現在の天気
                    VStack {
                        HStack {
                            Text("現在の天気")
                                .foregroundColor(Color("Text_MainColor"))
                                .font(fontSize)
                            
                            Spacer()
                        }
                        WeatherView(viewModel: viewModel, isForecast: false)
                            .cornerRadius(30)
                    } // VS
                    
                    Spacer()
                    
                    // 1時間後の天気
                    VStack {
                        HStack {
                            Text("今後の天気")
                                .foregroundColor(Color("Text_MainColor"))
                                .font(fontSize)
                            
                            Spacer()
                        }
                        WeatherView(viewModel: viewModel, isForecast: true)
                            .cornerRadius(30)
                    } // VS
                    
                    Spacer()
                } // HS
                .frame(minHeight: 100)
                .overlay(
                    VStack {
                        Spacer()
                        Image("Weather_Arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 70, maxWidth: 100)
                    }
                )
                
                // MARK: - 現在の気圧
                HStack {
                    Text("現在の気圧")
                        .foregroundColor(Color("Text_MainColor"))
                        .font(fontSize)
                        .padding(.top, 10)
                    
                    Spacer()
                }
                PressureView(viewModel: viewModel)
                    .frame(minHeight: 70)
                    .cornerRadius(30)
                
                // MARK: - 表情で体調予想
                HStack {
                    Text("体調予想")
                        .foregroundColor(Color("Text_MainColor"))
                        .font(fontSize)
                        .padding(.top, 10)
                    
                    Spacer()
                }
                HealthFaceView(viewModel: viewModel)
                    .frame(minHeight: 160)
                    .cornerRadius(30)
                
                Spacer()
                
            } // VS
            .overlay {
                // 解説をMainViewの上に表示する
                if viewModel.isFaceDescriptionDisplayed {
                    // 解説のView
                    HealthFaceDescriptionView(isPresented: $viewModel.isFaceDescriptionDisplayed)
                }
            }
            .padding()
            
        } // ZS
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
