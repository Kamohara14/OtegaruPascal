//
//  HomeViewModel.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/16.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    // Model
    // 気圧計
    @Published private var barometerManager: BarometerManager = .shared
    // 天気
    @Published private var weatherManager: WeatherManager = .shared
    // 体調予測
    @Published private var healthManager: HealthManager = .shared
    // 設定
    @Published private var settingManager: SettingManager = .shared
    
    // MARK: - お薬の通知画面
    // お薬の通知の有無(デフォルトは表示しない)
    @Published var isDrugNotificationDisplayed: Bool = false {
        didSet {
            // 体調記録を通知するかどうかを保存
            UserDefaults.standard.set(isDrugNotificationDisplayed, forKey: "isDrugNotificationDisplayed")
        }
    }
    // お薬の名前
    @Published var drugTitle: String = "お薬を飲みましたか？"
    
    // MARK: - 天気予報の画面
    // 現在の天気
    @Published var weatherImage: WeatherIcon = WeatherIcon(type: .not)
    // 現在の天気の解説
    @Published var weatherDescription: String = "天気"
    // 現在の気温
    @Published var temp: String = "気温"
    // 現在の湿度(%)
    @Published var humidity: String = "湿度"
    // 現在のUV指数
    @Published var uvi: String = "UV指数"
    // 現在の曇り度(%)
    @Published var clouds: String = "曇り度"
    // 現在の風速(m/s)
    @Published var windSpeed: String = "風速"
    // 現在の降水確率(0~1) *0が0%で、1が100%
    @Published var pop: String = "降水確率"
    
    // 今後の天気
    @Published var weatherForecastImage: WeatherIcon = WeatherIcon(type: .not)
    // 今後の天気の解説
    @Published var weatherForecastDescription: String = "天気"
    // 今後の気温
    @Published var forecastTemp: String = "気温"
    // 今後の湿度(%)
    @Published var forecastHumidity: String = "湿度"
    // 今後のUV指数
    @Published var forecastUvi: String = "UV指数"
    // 今後の曇り度(%)
    @Published var forecastClouds: String = "曇り度"
    // 今後の風速(m/s)
    @Published var forecastWindSpeed: String = "風速"
    // 今後の降水確率(0~1) *0が0%で、1が100%
    @Published var forecastPop: String = "降水確率"
    
    // MARK: - 現在の気圧の画面
    // 気圧を文字列にして表示
    @Published var pressureString: String = "0000.0hPa"
    // 過去の気圧からどう変化したかを矢印で表す(デフォルトは変化なし)
    @Published var pressureArrow: PressureArrowIcon = PressureArrowIcon(type: .not)
    
    // MARK: - 表情で体調予想の画面
    // 過去の体調を表情で表現する
    @Published var pastFace: FaceType = .not
    // 現在の体調を表情で表現する
    @Published var currentFace: FaceType = .not
    // 予測された体調を表情で表現する
    @Published var forecastFace: FaceType = .not
    // 表情の解説の有無
    @Published var isFaceDescriptionDisplayed: Bool = false
    // 現在の体調について一言解説
    @Published var description: DescriptionType = .not
    
    // MARK: - init
    init() {
        // お薬通知の画面表示の有無を入れる
        isDrugNotificationDisplayed = UserDefaults.standard.bool(forKey: "isDrugNotificationDisplayed")
        
        // 更新開始
        // FIXME: API呼び出し回数に制限があるため、何度も起動するテストではupdateWeather()を呼び出さない。本番時には呼び出すよう変更すること。
        updateWeather()
        updateBarometer()
        updateHelth()
    }
    
    // MARK: - updateWeather
    // 天気の更新を開始する
    func updateWeather() {
        // 天気(緯度経度を渡す)
        self.weatherManager.updateWeather { weather, weatherForcast in
            // 現在の天気を更新
            self.weatherImage = WeatherIcon(type: weather.main)
            self.weatherDescription = "天候\n\(weather.description)"
            self.temp = "気温\n\(weather.temp)℃"
            self.humidity = "湿度\n\(Int(weather.humidity))%"
            self.uvi = "UV指数\n\(weather.uvi)"
            self.clouds = "曇り度\n\(Int(weather.clouds))%"
            self.windSpeed = "風速\n\(weather.windSpeed) m/s"
            self.pop = "降水確率\n\(Int(weather.pop * 100))%"
            
            // 今後の天気を更新
            self.weatherForecastImage = WeatherIcon(type: weatherForcast.main)
            self.weatherForecastDescription = "天候\n\(weatherForcast.description)"
            self.forecastTemp = "気温\n\(weatherForcast.temp)℃"
            self.forecastHumidity = "湿度\n\(Int(weatherForcast.humidity))%"
            self.forecastUvi = "UV指数\n\(weatherForcast.uvi)"
            self.forecastClouds = "曇り度\n\(Int(weatherForcast.clouds))%"
            self.forecastWindSpeed = "風速\n\(weatherForcast.windSpeed) m/s"
            self.forecastPop = "降水確率\n\(Int(weatherForcast.pop * 100))%"
        }
    }
    
    // MARK: - updateBarometer
    // 気圧の更新を開始する
    func updateBarometer() {
        // 気圧計
        self.barometerManager.updateAltimeter { pressure in
            // 現在の気圧を文字列に変換し、表示用に整える
            self.pressureString = String(format: "%.1f", pressure) + "hPa"
            // 過去の気圧から気圧が上がっているかどうかを確認する
            self.pressureArrow = PressureArrowIcon(type: self.healthManager.getPressureArrow())
            // 現在の体調の解説を取得
            self.description = self.healthManager.getDescription()
        }
    }
    
    // MARK: - updateHelth
    // 体調の更新を開始する
    func updateHelth() {
        self.healthManager.updateHealth { past, current, forecast in
            // 過去の体調を取得
            self.pastFace = past
            // 現在の体調を取得
            self.currentFace = current
            // 予測された体調を取得
            self.forecastFace = forecast
            
            // お薬通知の画面表示をしていなかったら
            if !self.isDrugNotificationDisplayed {
                // お薬通知の画面表示の有無を受け取る
                self.isDrugNotificationDisplayed = self.healthManager.getIsDrugNotificationDisplayed()
            }
            
            // 登録されているお薬があるなら
            if self.settingManager.getRegisteredDrug() != "" {
                // 登録されているお薬の名前を入れる
                self.drugTitle = "お薬「\(self.settingManager.getRegisteredDrug())」を飲みましたか？"
            } else {
                // ないならデフォルト表示
                self.drugTitle = "お薬を飲みましたか？"
            }
            
        }
    }

}

// MARK: - WeatherType
// 天気アイコンの種類
enum WeatherType: String, Codable {
    // 晴れ
    case clear = "Clear"
    // 曇り
    case clouds = "Clouds"
    // 俄雨
    case drizzle = "Drizzle"
    // 雨
    case rain = "Rain"
    // 雷雨
    case thunderstorm = "Thunderstorm"
    // 雪
    case snow = "Snow"
    // 霧
    case mist = "Mist"
    case smoke = "Smoke"
    case haze = "Haze"
    case dust = "Dust"
    case fog = "Fog"
    case sand = "Sand"
    case ash = "Ash"
    case squall = "Squall"
    case tornado = "Tornado"
    // 受け取らない場合
    case not = ""
}

// MARK: - Weather
// 天気アイコン
struct WeatherIcon {
    let type: WeatherType
    let icon: (image: String, color1: Color, color2: Color)
    
    init(type: WeatherType) {
        self.type = type
        
        switch type {
        case .clear:
            // 晴れ
            self.icon = ("sun.max.fill", Color("Weather_Sunny"), Color("Weather_Sunny"))
            
        case .clouds:
            // 曇り
            self.icon = ("cloud.fill", Color("Weather_Cloudy"), Color("Weather_Cloudy"))
            
        case .drizzle :
            // 俄雨
            self.icon = ("cloud.rain.fill", Color("Weather_Cloudy"), Color("Weather_Rain"))
            
        case .rain:
            // 雨
            self.icon = ("umbrella.fill", Color("Weather_Rain"), Color("Weather_Rain"))
            
        case .thunderstorm:
            // 雷
            self.icon = ("cloud.bolt.rain.fill", Color("Weather_Thunder"), Color("Weather_Rain"))
            
        case .snow:
            // 雪
            self.icon = ("snowflake", Color("Weather_Snow"), Color("Weather_Snow"))
            
        case .mist, .smoke, .haze, .dust, .fog, .sand, .ash, .squall, .tornado:
            // その他
            self.icon = ("cloud.fog.fill", Color("Weather_Cloudy"), Color("Weather_Snow"))
        case .not:
            // 表示しない
            self.icon = ("circle.slash", Color("Text_Black"), Color("Text_Black"))
        }
    }
}

// MARK: - PressureArrowType
// 気圧変化を表す矢印のアイコンの種類
enum PressureArrowType: String {
    case up = "arrow.up.forward.circle.fill"
    case right = "arrow.forward.circle.fill"
    case down = "arrow.down.right.circle.fill"
    case not = "xmark.circle.fill"
}

// MARK: - PressureArrow
// 気圧変化を表す矢印のアイコン
struct PressureArrowIcon {
    let type: PressureArrowType
    let color: Color
    
    init(type: PressureArrowType) {
        self.type = type
        
        switch type {
        case .up:
            // 気圧が上昇した時
            self.color = Color("Arrow_Up") // 青
            
        case .right:
            // 気圧があまり変わらない時
            self.color = Color("Arrow_Right") // 緑
            
        case .down:
            // 気圧が下降した時
            self.color = Color("Arrow_Down") // 赤
            
        case .not:
            // 初期表示及びデータの取得失敗時
            self.color = Color("Text_Black") // 黒
        }
        
    }
}

// MARK: - FaceType
// 表情の種類
enum FaceType: String, Codable {
    case good = "Face_Good"
    case normal = "Face_Normal"
    case bad = "Face_Bad"
    case worst = "Face_Worst"
    case not = "Face_Not"
}

// MARK: - DescriptionType
enum DescriptionType: String {
    case good = "良好です"
    case normal = "通常通りです"
    case bad = "注意が必要です"
    case worst = "警戒して下さい"
    case not = "記録なし"
}
