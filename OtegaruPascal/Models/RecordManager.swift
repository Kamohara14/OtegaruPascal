//
//  RecordManager.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/10.
//

import Foundation

struct Record: Identifiable, Codable {
    // ID
    var id = UUID()
    // 記録された日付
    let date: String
    // 体調の評価(4段階)
    let evaluation: Int
}

final class RecordManager: ObservableObject {
    // シングルトン
    static let shared: RecordManager = .init()
    
    // Model
    @Published private var healthManager: HealthManager = .shared
    @Published private var notificationManager: NotificationManager = .shared
    
    // 記録の配列
    private var recordArray: [Record] = [] {
        // 変更があれば
        didSet {
            // 通知を保存
            saveRecord(data: recordArray)
        }
    }
    // 記録の最大数(30件まで)
    private let maxRecord: Int = 29
    // 記録が削除されたかどうか
    private var deleteFlag: Bool = false
    
    // MARK: - init
    init() {
        // 記録を入れる
        if let data = UserDefaults.standard.data(forKey: "record") {
            if let getData = try? JSONDecoder().decode([Record].self, from: data) {
                recordArray = getData
            }
        }
    }
    
    // MARK: - addRecord
    // 記録を追加(体調の評価を受け取る)
    func addRecord(evaluation: Int){
        // 記録の数が最大数を超えたら
        if recordArray.count > maxRecord {
            // 古い記録から削除する
            for num in maxRecord..<recordArray.count {
                recordArray.remove(at: num)
            }
        }
        
        // 日付
        let date = Date()
        // フォーマッター
        let formatter = DateFormatter()
        // 西暦に変換
        formatter.calendar = Calendar(identifier: .gregorian)
        // 日付のフォーマットを指定
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        // フォーマットした日付
        let fDate = formatter.string(from: date)
        
        // 配列に入れる
        recordArray.insert(Record(date: fDate, evaluation: evaluation), at: 0)
        
        // 評価を参考に各ユーザ毎に通知のチューニングをする
        healthManager.changeHealthLine(evaluation: evaluation)
        healthManager.forecastHealth()
    }
    
    // MARK: - saveRecord
    private func saveRecord(data: [Record]) {
        // 記録の配列を保存
        guard let data = try? JSONEncoder().encode(data) else { return }
        UserDefaults.standard.set(data, forKey: "record")
    }
    
    // MARK: - deleteRecord
    func deleteRecord() {
        // 記録を空にする
        recordArray = []
        // 削除した
        deleteFlag = true
    }
    
    // MARK: - getRecord
    func getRecord() -> [Record] {
        // 記録の配列を返す
        return recordArray
    }
    // MARK: - getDeleteFlag
    func getDeleteFlag() -> Bool {
        // 削除されたかどうかを返す
        return deleteFlag
    }
}
