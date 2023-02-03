//
//  SettingViewModel.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/21.
//

import Foundation
import SwiftUI

final class SettingViewModel: ObservableObject {
    // Model
    @Published private var settingManager: SettingManager = .shared
    
    // MARK: - お薬情報
    // お薬情報を通知するかどうか(デフォルトはON)
    @Published var isDrugNotification: Bool = true {
        didSet {
            // お薬情報を通知するかどうかを保存
            settingManager.setDrugNotification(data: isDrugNotification)
        }
    }
    
    // 登録された薬(未登録の場合もある)
    @Published var registeredDrug: String = "" {
        didSet {
            settingManager.setRegisteredDrug(data: registeredDrug)
        }
    }
    
    // MARK: - 体調記録
    // 体調記録を通知するかどうか(デフォルトはON)
    @Published var isRecordNotification: Bool = true {
        didSet {
            // 体調記録を通知するかどうかを保存
            settingManager.setRecordNotification(data: isRecordNotification)
        }
    }
    
    // 体調記録をする時間(デフォルトは18時)、Intに変換して使用する
    @Published var recordTime: Double = 18.0 {
        didSet {
            // 体調記録をする時間を保存
            settingManager.setRecordTime(data: recordTime)
        }
    }
    
    // MARK: - init
    init() {
        // お薬通知を入れる
        isDrugNotification = settingManager.getDrugNotification()
        // 登録されたお薬を入れる
        registeredDrug = settingManager.getRegisteredDrug()
        // 記録通知を入れる
        isRecordNotification = settingManager.getRecordNotification()
        // 記録をつける時間を入れる
        recordTime = settingManager.getRecordTime()
    }
    
    // MARK: - deleteRegisteredDrug
    // 登録されたお薬を削除する
    func deleteRegisteredDrug() {
        // お薬が登録されていたら
        if registeredDrug != "" {
            // 登録されたお薬を削除する
            registeredDrug = ""
        }
    }
    
    // MARK: - deleteNotification
    func deleteNotification() {
        // 通知を削除する処理
        settingManager.deleteNotification()
    }
}
