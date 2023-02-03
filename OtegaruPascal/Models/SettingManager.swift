//
//  SettingManager.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/21.
//

import Foundation

final class SettingManager: ObservableObject {
    // シングルトン
    static let shared: SettingManager = .init()
    
    // Model
    @Published private var notificationManager: NotificationManager = .shared
    
    // MARK: - お薬情報
    // お薬情報を通知するかどうか(デフォルトはON)
    private var isDrugNotification: Bool = true {
        didSet {
            // お薬情報を通知するかどうかを保存
            UserDefaults.standard.set(isDrugNotification, forKey: "isDrug")
        }
    }
    
    // 登録されたお薬
    private var registeredDrug: String {
        didSet {
            // 登録されたお薬を保存
            UserDefaults.standard.set(registeredDrug, forKey: "registeredDrug")
        }
    }
    
    // MARK: - 体調記録
    // 体調記録を通知するかどうか(デフォルトはON)
    private var isRecordNotification: Bool = true {
        didSet {
            // 体調記録を通知するかどうかを保存
            UserDefaults.standard.set(isRecordNotification, forKey: "isRecord")
        }
    }
    
    // 体調記録をする時間(デフォルトは18時)、Intに変換して使用する
    private var recordTime: Double = 18.0 {
        didSet {
            // 体調記録をする時間を保存
            UserDefaults.standard.set(recordTime, forKey: "recordTime")
        }
    }
    
    // MARK: - init
    init() {
        // お薬通知を入れる
        isDrugNotification = UserDefaults.standard.object(forKey: "isDrug") as? Bool ?? true
        // 登録されたお薬を入れる
        registeredDrug = UserDefaults.standard.string(forKey: "registeredDrug") ?? ""
        // 記録通知を入れる
        isRecordNotification = UserDefaults.standard.object(forKey: "isRecord") as? Bool ?? true
        // 記録をつける時間を入れる(初回起動時は保存されたデータが存在しないため、代入しない)
        if UserDefaults.standard.double(forKey: "recordTime") != 0.0 {
            recordTime = UserDefaults.standard.double(forKey: "recordTime")
        }
    }
    
    // MARK: - DrugNotification
    // setter
    func setDrugNotification(data: Bool) {
        isDrugNotification = data
    }
    // getter
    func getDrugNotification() -> Bool {
        return isDrugNotification
    }
    
    // MARK: - RegisteredDrug
    // setter
    func setRegisteredDrug(data: String) {
        registeredDrug = data
    }
    // getter
    func getRegisteredDrug() -> String {
        return registeredDrug
    }
    
    // MARK: - RecordNotification
    // setter
    func setRecordNotification(data: Bool) {
        isRecordNotification = data
    }
    // getter
    func getRecordNotification() -> Bool {
        return isRecordNotification
    }
    
    // MARK: - RecordTime
    // setter
    func setRecordTime(data: Double) {
        recordTime = data
    }
    // getter
    func getRecordTime() -> Double {
        return recordTime
    }
    
    // MARK: - deleteNotification
    func deleteNotification() {
        // 通知を削除する処理
        notificationManager.deleteNotification()
    }
}
