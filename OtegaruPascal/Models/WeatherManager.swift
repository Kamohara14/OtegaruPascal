//
//  WeatherManager.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/21.
//

import Foundation
import Network // API通信を行うかどうかの判断に必要
import Combine // JSON取得の際に使用

// MARK: - WeatherInput
struct WeatherInput: Identifiable {
    // ID
    let id: UUID = UUID()
    // 予測時刻(UTC基準)
    let dt: Int
    // 温度(℃)
    let temp: Double
    // 天気
    let main: WeatherType
    // 天気の解説(日本語)
    let description: String
    // 湿度(%)
    let humidity: Double
    // UV指数
    let uvi: Double
    // 曇り度(%)
    let clouds: Int
    // 風速(m/s)
    let windSpeed: Double
    // 降水確率(0~1) *0が0%で、1が100%
    let pop: Double
}

final class WeatherManager: ObservableObject {
    enum WeatherInputs {
        // 緯度経度を渡す
        case onCommit(lat: Double, lon: Double)
    }
    // シングルトン
    static let shared: WeatherManager = .init()
    
    // 更新のためのタイマー
    private var timer: Timer?
    
    // MARK: - OpenWeatherMap(OneCall-2.5)
    // 通信できるかどうか
    private var isNetwork = false
    // API呼び出し
    private let weatherCall: APIService
    
    // MARK: -  Publisher
    // APIリクエストが完了時に発行するSubject
    private let responseSubject = PassthroughSubject<WeatherRequest, Never>()
    // エラー時に発行するSubject
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    // Cancellable
    private var cancellable = Set<AnyCancellable>()
    
    // 表示するデータ
    private(set) var weatherInput: (WeatherInput, WeatherInput) = (
        WeatherInput(dt: 0, temp: 15.0, main: .not, description: "", humidity: 0.0, uvi: 0.0, clouds: 0, windSpeed: 0.0, pop: 0.0),
        WeatherInput(dt: 0, temp: 15.0, main: .not, description: "", humidity: 0.0, uvi: 0.0, clouds: 0, windSpeed: 0.0, pop: 0.0))
    // 年間の平均温度
    private var tempArray: [Double] = [5.4, 6.1, 9.4, 14.3, 18.8, 21.9, 25.7, 26.9, 23.3, 18.0, 12.5, 7.7]
    // 温度
    private var temperature: Double = 15.0
    // 緯度・経度(デフォルトはTokyo)
    private var lat: Double = 35.69 {
        didSet {
            // 保存
            UserDefaults.standard.set(lat, forKey: "lat")
        }
    }
    private var lon: Double = 139.69 {
        didSet {
            // 保存
            UserDefaults.standard.set(lon, forKey: "lon")
        }
    }
    
    // MARK: - init
    init() {
        // 緯度・経度を入れる
        if UserDefaults.standard.double(forKey: "lat") != 0.0 {
            lat = UserDefaults.standard.double(forKey: "lat")
        }
        if UserDefaults.standard.double(forKey: "lon") != 0.0 {
            lon = UserDefaults.standard.double(forKey: "lon")
        }
        
        // APIの呼び出しを入れる
        self.weatherCall = APIService()
        
        // ネットワーク通信ができるかチェックする
        isCheckNetwork()
        // JSON取得のCombine
        bind()
        
    }
    
    // MARK: - isNetwork
    // ネットワークが使用可能か確認する
    private func isCheckNetwork(){
        // モニター
        let monitor = NWPathMonitor()
        // ハンドラで処理を指定
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // ネットワークが使えるならAPIをリクエストする
                print("Connected!!")
                self.isNetwork = true
                
            } else {
                // 使えないならAPIをリクエスト使用しない
                print("Not Connected...")
                self.isNetwork = false
                
            }
        }
        // queueの設定
        let queue = DispatchQueue(label: "com.network")
        // モニター開始
        monitor.start(queue: queue)
    }
    
    // MARK: - bind
    // Combineを使用した別スレッドの処理
    private func bind() {
        responseSubject
            .flatMap { weatherRequest in
                self.weatherCall.request(with: weatherRequest)
            }
            .catch { error -> Empty<WeatherResponse, Never> in
                // エラーを表示
                print("")
                print(error)
                self.errorSubject.send(error)
                return Empty()
            }
            .map { $0 }
            .sink { response in
                self.convertInput(response: response)
                print(" -- JSON取得完了 -- ")
            }
            .store(in: &cancellable)
    }
    
    // MARK: - updateWeather
    // 一定間隔で天気を取得し、結果をHomeViewに返す
    func updateWeather(handler: @escaping (WeatherInput, WeatherInput) -> Void) {
        // 通信できる時のみ実行
        if isNetwork {
            // 緯度経度を渡してAPIを取る
            apply(input: WeatherInputs.onCommit(lat: lat, lon: lon))
            // APIが取れたら
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // 天気を取得
                let weather: WeatherInput = self.weatherInput.0
                let weatherForcast: WeatherInput = self.weatherInput.1
                print("2: \(self.weatherInput.0.main) -> \(self.weatherInput.1.main)")
                
                // 天気を返す
                handler(weather, weatherForcast)
            }
            
            // 10分ごとに更新
            timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { _ in
                // 緯度経度を渡してAPIを取る
                self.apply(input: WeatherInputs.onCommit(lat: self.lat, lon: self.lon))
                
                // APIが取れたら
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // 天気を取得
                    let weather: WeatherInput = self.weatherInput.0
                    let weatherForcast: WeatherInput = self.weatherInput.1
                    print("2: \(self.weatherInput.0.main) -> \(self.weatherInput.1.main)")
                    
                    // 天気を返す
                    handler(weather, weatherForcast)
                }
            }
            
        } else {
            // 月を取得する
            let date = Date()
            let month = Calendar.current.component(.month, from: date)
            // 平均気温をいれる
            self.temperature = tempArray[month - 1]
            
        }
        
    }
    
    // MARK: - convertInput
    // 取得した天気情報を代入する
    private func convertInput(response: WeatherResponse) {
        // 現在の天気情報
        var currentInputs = WeatherInput(dt: 0, temp: 15.0, main: .not, description: "エラー", humidity: 0.0, uvi: 0.0, clouds: 0, windSpeed: 0.0, pop: 0.0)
        // 1時間後の天気情報
        var forcastInputs = WeatherInput(dt: 0, temp: 15.0, main: .not, description: "エラー", humidity: 0.0, uvi: 0.0, clouds: 0, windSpeed: 0.0, pop: 0.0)
        
        // 取ってきたデータがあるなら
        if let currentData = response.hourly?[0],
           let forcastData = response.hourly?[1] {
            
            // 温度を取得
            self.temperature = currentData.temp
            
            // データを代入
            currentInputs = WeatherInput(
                dt: currentData.dt, temp: currentData.temp,
                main: currentData.weather[0].main,
                description: currentData.weather[0].description,
                humidity: currentData.humidity,
                uvi: currentData.uvi,
                clouds: currentData.clouds,
                windSpeed: currentData.windSpeed,
                pop: currentData.pop
            )
            
            forcastInputs = WeatherInput(
                dt: forcastData.dt, temp: forcastData.temp,
                main: forcastData.weather[0].main,
                description: forcastData.weather[0].description,
                humidity: forcastData.humidity,
                uvi: forcastData.uvi,
                clouds: forcastData.clouds,
                windSpeed: forcastData.windSpeed,
                pop: currentData.pop
            )
        }
        // 天気を取得
        self.weatherInput = (currentInputs, forcastInputs)
        // 天気を確認
        print("1: \(currentInputs.main) -> \(forcastInputs.main)")
    }
    
    // MARK: - apply
    // 別スレッドの処理を行う
    private func apply(input: WeatherInputs) {
        switch input {
        case .onCommit(lat: let lat, lon: let lon):
            // 経度緯度からJSONをとる
            responseSubject.send(WeatherRequest(lat: String(lat), lon: String(lon)))
        }
    }
    
    // MARK: - getTemperature
    func getTemperature() -> Double {
        // 温度を返す
        return temperature
        
    }
    
    // MARK: - setCoordinate
    func setCoordinate(lat: Double, lon: Double) {
        // 緯度経度を入れる
        self.lat = lat
        self.lon = lon
        
    }
    
}
