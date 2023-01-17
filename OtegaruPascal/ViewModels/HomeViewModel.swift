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
    
    // MARK: - お薬の通知画面
    // お薬の通知の有無(デフォルトは表示しない)
    @Published var isDrugNotificationDisplayed: Bool = false {
        didSet {
            // 体調記録を通知するかどうかを保存
            UserDefaults.standard.set(isDrugNotificationDisplayed, forKey: "isDrugNotificationDisplayed")
        }
    }
    // お薬の画像
    @Published var drugImage: String = ""
    
    // MARK: - 天気予報の画面
    // 現在の天気
    @Published var weatherImage: WeatherIcon = WeatherIcon(type: .not)
    // 今後の天気
    @Published var weatherForecastImage: WeatherIcon = WeatherIcon(type: .not)
    
    
    // MARK: - 現在の気圧の画面
    // 気圧を文字列にして表示
    @Published var pressureString: String = "0000.0hPa"
    // 過去の気圧からどう変化したかを矢印で表す(デフォルトは変化なし)
    @Published var pressureArrow: PressureArrowIcon = PressureArrowIcon(type: .not)
    
    // MARK: - 表情で体調予想の画面
    // 過去の体調を表情で表現する(デフォルトはgood)
    @Published var pastFace: FaceType = .good
    // 現在の体調を表情で表現する(デフォルトはnormal)
    @Published var currentFace: FaceType = .normal
    // 予測された体調を表情で表現する(デフォルトはbad)
    @Published var forecastFace: FaceType = .bad
    // 表情の解説の有無
    @Published var isFaceDescriptionDisplayed: Bool = false
    // 現在の体調について一言解説
    @Published var description: DescriptionType = .not
    
    // MARK: - init
    init() {
        // お薬通知の画面表示の有無を入れる
        isDrugNotificationDisplayed = UserDefaults.standard.bool(forKey: "isDrugNotificationDisplayed")
        
        // 更新開始
        updateWeather()
        updateBarometer()
        updateHelth()
    }
    
    // MARK: - updateWeather
    func updateWeather() {
        // 天気(緯度経度を渡す)
        self.weatherManager.updateWeather { weather, weatherForcast in
            // 天気を更新
            self.weatherImage = weather
            self.weatherForecastImage = weatherForcast
        }
    }
    
    // MARK: - updateBarometer
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
    let icon: (String, Color, Color)
    
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
