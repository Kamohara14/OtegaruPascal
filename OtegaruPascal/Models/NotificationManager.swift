//
//  NotificationManager.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/20.
//

import Foundation
import UserNotifications // 通知用

// 通知の構造体
struct Notification: Identifiable, Codable {
    // ID
    var id = UUID()
    // タイトル
    let title: String
    // 日付
    let date: String
    // 既読かどうか
    var isRead: Bool
    
}

final class NotificationManager: ObservableObject {
    // シングルトン
    static let shared: NotificationManager = .init()
    
    // 通知の配列
    private var notificationArray: [Notification] = [] {
        // 変更があれば
        didSet {
            // 通知を保存
            saveNotification(data: notificationArray)
        }
    }
    // 通知の最大数(20件まで)
    private let maxNotification: Int = 19
    // 通知許可の有無
    private var isPermitNotification = false
    
    // MARK: - init
    init() {
        // 通知を入れる
        if let data = UserDefaults.standard.data(forKey: "notification") {
            if let getData = try? JSONDecoder().decode([Notification].self, from: data) {
                notificationArray = getData
            }
        }
    }
    
    // MARK: - permitNotification
    // 通知の許可をとる(返り値を使用しない場合がある)
    @discardableResult
    func permitNotification() -> Bool {
        // 通知の許可状況
        var permit = false
        // 通知のリセット
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // 通知を許諾するかどうか表示する(初使用時のみ)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge]){
            (granted, error) in
            
            // エラーが発生したら
            if error != nil {
                print("通知許諾エラー")
                return
            }
            // 通知を許可しているかどうか
           permit = granted
            
        }
        
        return permit
    }
    
    // MARK: - makeNotification
    // ローカル通知を作成する
    func makeNotification(type: NotificationType, registeredDrug: String, pressureEffect: String) {
        // 通知許可の確認
        if permitNotification() {
            print("通知は許可されていません")
            return
        }
        // 通知タイミング(即時に通知する, 繰り返さない)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        // 通知の内容
        let content = UNMutableNotificationContent()
        // identifier
        let identifier: String
        
        switch type {
        case .health:
            // 体調予想の通知
            content.title = "体調不良が予想されます" + pressureEffect
            identifier = "notification_health"
            
        case .drug:
            // お薬通知
            if registeredDrug != "" {
                // 登録されたお薬を表示
                content.title = "「" + registeredDrug + "」を飲みましょう"
            } else {
                content.title = "お薬を飲みましょう"
            }
            identifier = "notification_drug"
            
        case .record:
            // 体調記録の通知
            content.title = "体調の記録をつけましょう"
            identifier = "notification_record"
            
        }
        // タイトル確認
        print("通知タイトル： \(content.title)")
        // テキスト
        content.body = "タップでAppを開く"
        // サウンド(デフォルト)
        content.sound = UNNotificationSound.default
        
        //リクエスト作成
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //リクエスト実行
        UNUserNotificationCenter.current().add(request)
        // 通知追加
        addNotification(type: type, pressureEffect: pressureEffect)
    }
    
    // MARK: - addNotification
    // 通知画面に通知を追加する
    private func addNotification(type: NotificationType, pressureEffect: String) {
        // 通知の数が最大数を超えたら
        if notificationArray.count > maxNotification {
            // 古い通知から削除する
            for num in maxNotification..<notificationArray.count {
                notificationArray.remove(at: num)
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
        
        // 通知のタイトル
        let title: String
        
        switch type {
        case .health:
            title = "体調不良が予想されます" + pressureEffect
        case .drug:
            title = "お薬を飲みましょう"
        case .record:
            title = "体調の記録をつけましょう"
        }
        
        // 配列に入れる(isRead: 未読の状態で入れる)
        notificationArray.insert(Notification(title: title, date: fDate, isRead: false), at: 0)
    }
    
    // MARK: - saveNotification
    private func saveNotification(data: [Notification]) {
        // 通知の配列を保存
        guard let data = try? JSONEncoder().encode(data) else { return }
        UserDefaults.standard.set(data, forKey: "notification")
    }
    
    // MARK: - readNotification
    func readNotification(num: Int) {
        // 既読にする
        notificationArray[num].isRead = true
    }
    
    // MARK: - deleteNotification
    func deleteNotification() {
        // 通知を空にする
        notificationArray = []
    }
    
    // MARK: - getNotification
    func getNotification() -> [Notification] {
        // 通知の配列を返す
        return notificationArray
    }
    
    // MARK: - getIsRead
    // 未読の有無と、未読の数を返す
    func getIsRead() -> (Bool, Int) {
        // 未読の数
        var unreadNum = 0
        
        // 未読があるかどうかを調べる
        for notification in notificationArray {
            // もし未読なら
            if notification.isRead == false {
                // 未読件数を数える
                unreadNum += 1
            }
        }
        
        if unreadNum == 0 {
            // 全て既読である
            return (true, 0)
            
        } else {
            // 未読が存在する
            return (false, unreadNum)
        }
    }
}
