//
//  WeatherResponse.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/22.
//

import Foundation

// MARK: - Weather
struct WeatherResponse: Codable {
    // 緯度経度
    let lat, lon: Double
    // リクエストされた場所のタイムゾーン
    let timezone: String
    // UTCから秒単位のシフト
    let timezoneOffset: Int
    // 1時間ごとの予報
    let hourly: [Hourly]?
}

// MARK: - Hourly
struct Hourly: Codable {
    // 予測時刻(UTC基準)
    let dt: Int
    // 温度(℃)
    let temp: Double
    // 人間が知覚している温度(℃)
    let feelsLike: Double
    // 気圧(hPa)
    let pressure: Double
    // 湿度(%)
    let humidity: Double
    // 露が形成される大気温度(℃)
    let dewPoint: Double
    // UV指数
    let uvi: Double
    // 曇り度(%)
    let clouds: Int
    // 平均視程(m)最大値は10km
    let visibility: Int
    // 風速(m/s)
    let windSpeed: Double
    // 風向き(度)
    let windDeg: Int
    // 突風(m/s) (突風がなかったら取れない)
    let windGust: Double?
    // 天気
    let weather: [Weather]
    // 降水確率(0~1) *0が0%で、1が100%
    let pop: Double
    // 降雨量 (雨が降ってなかったら取れない)
    let rain: Rain?
}

// MARK: - Rain
struct Rain: Codable {
    // 降雨量もしくは降雪量
    let the1H: Double?
}

// MARK: - Weather
struct Weather: Codable {
    // ID
    let id: Int
    // 天気のパラメータ
    let main: WeatherType
    // 天気の解説(日本語になる)
    let description: String
    // OpenWeather側のアイコン
    let icon: String
    
}
