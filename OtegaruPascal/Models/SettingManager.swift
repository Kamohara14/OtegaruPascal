//
//  SettingManager.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/21.
//

import Foundation

final class SettingManager: ObservableObject {    
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
    
    // 登録された薬
    private var registeredDrug: String {
        didSet {
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
            UserDefaults.standard.set(recordTime, forKey: "recordTime")
        }
    }
    
    // MARK: - init
    init() {
        // お薬通知を入れる
        isDrugNotification = UserDefaults.standard.bool(forKey: "isDrug")
        // 登録されたお薬を入れる
        registeredDrug = UserDefaults.standard.string(forKey: "registeredDrug") ?? ""
        // 記録通知を入れる
        isRecordNotification = UserDefaults.standard.bool(forKey: "isRecord")
        // 記録をつける時間を入れる(初回起動時は保存されたデータが存在しないため、代入しない)
        if UserDefaults.standard.double(forKey: "recordTime") != 0 {
            recordTime = UserDefaults.standard.double(forKey: "recordTime")
        }
    }
    
    // MARK: - DrugNotification
    func setDrugNotification(data: Bool) {
        isDrugNotification = data
    }
    
    func getDrugNotification() -> Bool {
        return isDrugNotification
    }
    
    // MARK: - RegisteredDrug
    func setRegisteredDrug(data: String) {
        registeredDrug = data
    }
    
    func getRegisteredDrug() -> String {
        return registeredDrug
    }
    
    // MARK: - RecordNotification
    func setRecordNotification(data: Bool) {
        isRecordNotification = data
    }
    
    func getRecordNotification() -> Bool {
        return isRecordNotification
    }
    
    // MARK: - RecordTime
    func setRecordTime(data: Double) {
        recordTime = data
    }
    
    func getRecordTime() -> Double {
        return recordTime
    }
    
    // MARK: - deleteNotification
    func deleteNotification() {
        // 通知を削除する処理
        notificationManager.deleteNotification()
    }
}
