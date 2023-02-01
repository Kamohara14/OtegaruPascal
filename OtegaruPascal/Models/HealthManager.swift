//
//  HealthManager.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/29.
//

import Foundation

final class HealthManager: ObservableObject {
    // シングルトン
    static let shared: HealthManager = .init()
    
    // Model
    @Published private var notificationManager: NotificationManager = .shared
    @Published private var settingManager: SettingManager = .shared
    
    // 過去の気圧の配列(年の平均気圧を時間ごとに入れておく)
    private var pastPressure: [Double] = [
        1014.0, 1013.0, 1013.0, 1013.0, 1013.0, 1014.0, 1015.0, 1016.0, // 0時~7時
        1017.0, 1018.0, 1017.0, 1016.0, 1015.0, 1014.0, 1013.0, 1012.0, // 8時~15時
        1011.0, 1012.0, 1013.0, 1014.0, 1015.0, 1016.0, 1016.0, 1015.0  // 16時~23時
    ] {
        // 変更があれば
        didSet {
            // 過去の気圧を保存
            savePressure(data: pastPressure)
        }
    }
    
    // 過去の体調
    private var pastFace: FaceType = .not
    // 現在の体調
    private var currentFace: FaceType = .not {
        // 変更があれば
        didSet {
            UserDefaults.standard.set(currentFace.rawValue, forKey: "face")
        }
    }
    // 予測された体調
    private var forecastFace: FaceType = .not
    // 体調に関する通知を出すかどうか
    private var isHealthNotification = false {
        didSet {
            UserDefaults.standard.set(isHealthNotification, forKey: "isHealthNotification")
        }
    }
    
    // 更新のためのタイマー
    private var timer: Timer?
    
    // 現在の時間(最初は必ず更新されるように-1にする)
    private var currentDay: Int = -1 {
        didSet {
            UserDefaults.standard.set(currentDay, forKey: "currentDay")
        }
    }
    
    private var currentHour: Int = -1 {
        didSet {
            UserDefaults.standard.set(currentHour, forKey: "currentHour")
        }
    }
    
    private var currentMin: Int = -1 {
        didSet {
            UserDefaults.standard.set(currentMin, forKey: "currentMin")
        }
    }
    
    // 経過時間の判定
    private var isDay = false
    private var isHour = false
    private var isMin = false
    
    // 気圧の差による体調の判断ライン
    private var healthLine: Double = 1.0 {
        // 変更があれば
        didSet {
            UserDefaults.standard.set(healthLine, forKey: "healthLine")
        }
    }
    
    // お薬通知の画面表示の有無(デフォルトは非表示)
    private var isDrugNotificationDisplayed: Bool = false
    
    // MARK: - init
    init() {
        // 過去の気圧を入れる
        if let data = UserDefaults.standard.data(forKey: "pastPressure") {
            if let getData = try? JSONDecoder().decode([Double].self, from: data) {
                pastPressure = getData
            }
        }
        // 体調の判断ラインを入れる(初回起動時は保存されたデータが存在しないため、代入しない)
        if UserDefaults.standard.double(forKey: "healthLine") != 0.0 {
            self.healthLine = UserDefaults.standard.double(forKey: "healthLine")
        }
        // 体調通知の状態を入れる
        isHealthNotification = UserDefaults.standard.bool(forKey: "isHealthNotification")
        
        // 現在の時間を入れるuserDefaultsの初期値を-1にする(値が既に入っている場合は初期値は無視される)
        UserDefaults.standard.register(defaults: ["currentDay" : -1, "currentHour" : -1, "currentMin" : -1])
        // 現在の時間を入れる
        if UserDefaults.standard.integer(forKey: "currentDay") != -1 {
            self.currentDay = UserDefaults.standard.integer(forKey: "currentDay")
        }
        if UserDefaults.standard.integer(forKey: "currentHour") != -1 {
            self.currentHour = UserDefaults.standard.integer(forKey: "currentHour")
        }
        if UserDefaults.standard.integer(forKey: "currentMin") != -1 {
            self.currentMin = UserDefaults.standard.integer(forKey: "currentMin")
        }
    }
    
    // MARK: - updateHealth
    // 一定間隔で体調についての情報を取得し、結果をHomeViewに返す
    func updateHealth(handler: @escaping (FaceType, FaceType, FaceType) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            // 時間確認
            self.updateTime()
            
            // 1時間毎に更新
            if self.isHour {
                // 現在の体調を過去の体調に入れる
                if let data = UserDefaults.standard.string(forKey: "face") {
                    self.pastFace = FaceType(rawValue: data) ?? .not
                }
            }
            
            // 1分毎に更新
            if self.isMin {
                // 体調予想
                self.forecastHealth()
                
                // 通知
                self.healthNotification()
                
                print("表情： \(self.pastFace) > \(self.currentFace) > \(self.forecastFace)")
            }
            
            // 過去、現在、予測された体調を返す
            handler(self.pastFace, self.currentFace, self.forecastFace)
        }
    }
    
    // MARK: - setPastPressure
    func setPastPressure(adjustedPressure: Double) {
        // 取得した気圧を記録する
        pastPressure.insert(adjustedPressure, at: currentHour)
    }
    
    // MARK: - savePressure
    func savePressure(data: [Double]) {
        // 過去の気圧の配列を保存
        guard let data = try? JSONEncoder().encode(data) else { return }
        UserDefaults.standard.set(data, forKey: "pastPressure")
    }
    
    // MARK: - forecastHealth
    // 体調の予測を行う
    func forecastHealth() {
        print("体調予測")
        // 過去の記録と現在の記録の差
        var pressureDifference: Double = 0.0
        // 過去の記録と現在の記録の差を求める
        if self.currentHour < 3 {
            // 3時間前が昨日の場合
            pressureDifference = self.pastPressure[21 + self.currentHour] - self.pastPressure[self.currentHour]
            
        } else {
            pressureDifference = self.pastPressure[self.currentHour - 3] - self.pastPressure[self.currentHour]
            
        }
        
        // 負の数なら
        if pressureDifference < 0 {
            // 正の数にする
            pressureDifference = pressureDifference * -1
        }
        
        // 気圧の差によって現在の体調を予測する
        if pressureDifference >= (self.healthLine * 6.5)  {
            // 警戒
            self.currentFace = .worst
            
        } else if pressureDifference >= (self.healthLine * 4.5) {
            // 注意
            self.currentFace = .bad
            
        } else if pressureDifference >= self.healthLine {
            // 通常通り
            self.currentFace = .normal
            
        } else if pressureDifference >= (self.healthLine - 2.0) {
            // 良好
            self.currentFace = .good
            
        } else {
            // 例外
            self.currentFace = .not
            
        }
        
        // 気圧の差によって今後の体調を予測する
        if pressureDifference >= (self.healthLine * 5.5)  {
            // 警戒
            self.forecastFace = .worst
            
        } else if pressureDifference >= (self.healthLine * 3.5) {
            // 注意
            self.forecastFace = .bad
            
        } else if pressureDifference >= (self.healthLine - 0.5) {
            // 通常通り
            self.forecastFace = .normal
            
        } else if pressureDifference >= (self.healthLine - 1.5) {
            // 良好
            self.forecastFace = .good
            
        } else {
            // 例外
            self.forecastFace = .not
            
        }
    }
    
    // MARK: - healthNotification
    // 体調の予測を行った結果から、ユーザに合わせたローカル通知を出す
    private func healthNotification() {
        print("体調予報の通知状態： \(isHealthNotification ? "待機" : "既出")")
        
        // 通知が出せる状態ならば実行
        if isHealthNotification {
            // 体調の悪化が予想されるなら
            if forecastFace == .bad || forecastFace == .worst {
                // 体調悪化の通知を出す
                notificationManager.makeNotification(type: .health, registeredDrug: settingManager.getRegisteredDrug())
                
                // アプリ側の許可がもらえたなら
                if settingManager.getDrugNotification() {
                    // お薬通知を出す
                    notificationManager.makeNotification(type: .drug,registeredDrug: settingManager.getRegisteredDrug())
                    // 画面にも通知を表示する
                    isDrugNotificationDisplayed = true
                    print("healthAndDrug")
                    
                } else {
                    print("health")
                }
                
                // 通知を1日に何度も送らないためにfalseにする
                isHealthNotification = false
            }
        }
        
    }
    
    // MARK: - changeHealthLine
    // 体調の指標となるラインをユーザ毎に合わせる
    func changeHealthLine(evaluation: Int) {
        // 現在の体調表示
        var num: Int
        // 現在の体調を数値化
        switch currentFace {
        case .good: num = 4
            break
            
        case .normal: num = 3
            break
            
        case .bad: num = 2
            break
            
        case .worst: num = 1
            break
            
        case .not: num = 0
            break
            
        }
        
        // 差を計算(ユーザが感じた体調 - 現在の体調)
        num = evaluation - num
        
        // ユーザ:1 アプリ:4 なら-3となり、基準を0.3下げる = 人より気圧に影響されやすい人向けに調整される
        // ユーザ:4 アプリ:1 なら+3となり、基準を0.3上げる = 人より気圧に影響されにくい人向けに調整される
        let calcNum = healthLine + (Double(num) * 0.1)
        print(" \(healthLine) + \(Double(num) * 0.1) = \(calcNum)")
        
        // 差が大きければ大きいほどユーザに合わせてチューニングする
        // 最低ラインは0、最高ラインは4とする
        if calcNum > 0.0 && 4.0 > calcNum {
            healthLine = calcNum
        }
        
        
    }
    
    // MARK: - updateTime
    // 日付を更新し、日付毎の処理を実行する
    func updateTime() {
        // 日付
        let date = Date()
        // カレンダー
        let calendar = Calendar.current
        // 時間を取得する
        let day = calendar.component(.day, from: date)      // 日
        let hour = calendar.component(.hour, from: date)    // 時
        let min = calendar.component(.minute, from: date)   // 分
        
        // 1日経ったかどうか
        if currentDay != day {
            // 現在の時間を入れる
            currentDay = day
            // 更新された
            isDay = true
            // 通知を出せる状態にする
            isHealthNotification = true
            print(" -- 1日経過 -- ")
            
        } else {
            // 更新されていない
            isDay = false
        }
        
        // 1時間経ったかどうか
        if currentHour != hour {
            // 現在の時間を入れる
            currentHour = hour
            // 更新された
            isHour = true
            print(" -- 1時間経過 -- ")
            
            // アプリ側の許可ももらえたなら
            if settingManager.getRecordNotification() {
                print("記録通知： ON")
                // 記録する時間になったら通知を送る(1日に1回)
                if Int(settingManager.getRecordTime()) == hour {
                    notificationManager.makeNotification(type: .record, registeredDrug: settingManager.getRegisteredDrug())
                }
                
            } else {
                print("記録通知： OFF")
            }
            
        } else {
            // 更新されていない
            isHour = false
        }
        
        // 1分経ったかどうか
        if currentMin != min {
            // 現在の時間を入れる
            currentMin = min
            // 更新された
            isMin = true
            print(" -- 1分経過 -- ")
            
        } else {
            // 更新されていない
            isMin = false
        }
        
    }
    
    // MARK: - getPressureArrow
    // 気圧表示の横の矢印を気圧に合わせて調整する
    func getPressureArrow() -> PressureArrowType {
        // 過去の記録と現在の記録の差
        var pressureDifference: Double
        // 気圧変化を表す矢印
        var pressureArrow: PressureArrowType = .not
        
        if self.currentHour == 0 {
            // 0時の場合は23時と比較する
            pressureDifference = self.pastPressure[23] - self.pastPressure[0]
        } else {
            // 0時以外はそのまま
            pressureDifference = self.pastPressure[self.currentHour - 1] - self.pastPressure[self.currentHour]
        }
        
        if -0.5 < pressureDifference && pressureDifference < 0.5 {
            // 気圧があまり変わらない場合
            pressureArrow = .right
            
        } else if pressureDifference > 0 {
            // 気圧下がった場合
            pressureArrow = .down
            
        } else if pressureDifference < 0 {
            // 気圧が上がった場合
            pressureArrow = .up
        }
        
        return pressureArrow
    }
    
    // MARK: - getDescription
    func getDescription() -> DescriptionType {
        // 現在の体調の解説を返す
        switch currentFace {
        case .good:
            return .good
            
        case .normal:
            return .normal
            
        case .bad:
            return .bad
            
        case .worst:
            return .worst
            
        case .not:
            return .not
        }
    }
    
    // MARK: - getIsDrugNotificationDisplayed
    func getIsDrugNotificationDisplayed() -> Bool {
        // お薬を飲んだかどうかを確認するホーム画面の通知を表示するかどうか
        if isDrugNotificationDisplayed {
            // 一度送ったら元に戻す
            isDrugNotificationDisplayed = false
            // 表示する
            return true
            
        } else {
            // 表示しない
            return false
            
        }
    }
    
    // MARK: - getIsHour
    func getIsHour() -> Bool {
        // 1時間経ったかどうか
        return isHour
    }
    
}
