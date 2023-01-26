//
//  BarometerManager.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/09/30.
//

import Foundation

// 気圧センサから気圧を取得
import CoreMotion
// GPSセンサから高度を取得
import CoreLocation

final class BarometerManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // シングルトン
    static let shared: BarometerManager = .init()
    
    // Model
    @Published private var healthManager: HealthManager = .shared
    @Published private var weatherManager: WeatherManager = .shared
    
    // MARK: - Altimeter
    // CMAltimeter(気圧計)
    private let altimeter: CMAltimeter
    
    // MARK: - LocationManager
    // CLLocationManager(GPS)
    private let locationManager: CLLocationManager
    // 標高(デフォルトは0m)
    private var altitude: Double = 0.0
    
    // MARK: - init
    private override init() {
        // CMAltimeterを入れる
        altimeter = CMAltimeter()
        // CLLocationManagerを入れる
        locationManager = CLLocationManager()
        
        super.init()
        locationManager.delegate = self
        // 精度の指定
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // ユーザに位置情報の使用許可を取る
        locationManager.requestWhenInUseAuthorization()
        
        // 位置情報が使用可能なら
        if CLLocationManager.locationServicesEnabled() {
            // バックグラウンドで使用するかどうか
            locationManager.allowsBackgroundLocationUpdates = true
            // 位置情報の取得を開始する
            locationManager.startUpdatingLocation()
            
        }
    }
    
    // MARK: - updateAltimeter
    // 一定間隔で気圧を取得し、結果をHomeViewに返す
    func updateAltimeter(handler: @escaping (Double) -> Void) {
        // 気圧計が使えるかどうか
        guard CMAltimeter.isRelativeAltitudeAvailable() else { return }
        
        // 気圧取得(連続して取得する)
        altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { data, error in
            // エラーなら処理をしない
            if error != nil {
                return
            }
            
            // 気圧を取得
            let pressure = data?.pressure.doubleValue ?? 0.0
            // 海面更正気圧を計算し、値を調整する
            let adjustedPressure = self.calcPressure(pressure: pressure) * 10
            
            // 1時間経ったなら
            if self.healthManager.getIsHour() {
                print("SetPastPressure!")
                // 過去の気圧にセットする
                self.healthManager.setPastPressure(adjustedPressure: adjustedPressure)
            }
            
            print("| 海面更正気圧： \(adjustedPressure) hPa | 気温： \(self.weatherManager.getTemperature()) 度")
            
            // 調整した気圧の値を送る
            handler(adjustedPressure)
            
        }
        
    }
    
    // MARK: - calcPressure
    private func calcPressure(pressure: Double) -> Double {
        // 海面更正気圧を計算
        let calc = 1.0 - (( 0.0065 * altitude) / (weatherManager.getTemperature() + 0.0065 * altitude + 273.15))
        let p0 = pressure * pow(calc, -5.257)
        
        // p0(海面更正気圧)を返す
        return p0
    }
    
    // MARK: - locationManagerDidChangeAuthorization
    // 位置情報の認証が変化すると処理が行われる
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 体調予想を更新する
        healthManager.updateTime()
        healthManager.forecastHealth()
    }
    
    // MARK: - locationManager
    // 位置情報が更新されるたびに処理が行われる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最終更新場所の位置情報が取れたなら
        if let location = locations.last {
            // 標高を更新
            self.altitude = location.altitude
            // 緯度経度を更新
            weatherManager.setCoordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
    }
}
