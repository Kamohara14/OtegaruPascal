//
//  NotificationViewModel.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/19.
//

import Foundation

final class NotificationViewModel: ObservableObject {
    // Model
    @Published private var notificationManager = NotificationManager.shared
    
    // 通知の配列
    @Published var notificationArray: [Notification] = []
    
    init() {
        // 通知を取ってくる
        notificationArray = notificationManager.getNotification()
    }
    
    // MARK: - readNotification
    func readNotification(num: Int) {
        // 既読にする
        notificationManager.readNotification(num: num)
        // 通知の更新
        notificationArray = notificationManager.getNotification()
    }
    
}

// MARK: - NotificationType
enum NotificationType {
    // 体調通知
    case health
    // お薬通知
    case drug
    // 記録通知
    case record
}
