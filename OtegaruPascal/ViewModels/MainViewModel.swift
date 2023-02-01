//
//  MainViewModel.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/12.
//

import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {
    // Model
    @Published private var notificationManager = NotificationManager.shared
    
    // 全て既読かどうか(未読の有無, 未読件数)
    @Published var isAllRead: (Bool, Int) = (true, 0)
    
    init() {
        // 既読かどうか確認
        isRead()
    }
    
    // MARK: - isRead
    func isRead() {
        // 既読かどうか調べた結果を格納する
        isAllRead = notificationManager.getIsRead()
    }
    
    // MARK: - permitNotification
    @discardableResult
    func permitNotification() -> Bool {
        // 通知許可の取得
        notificationManager.permitNotification()
    }
    
}

// MARK: - FontSizeType
// Viewの種類
enum Views {
    // 設定・通知
    case settingView
    // ホーム画面関連
    case homeView
    // 体調表示
    case healthFaceView
    // 体調解説
    case healthFaceDescriptionView
}

// MARK: - getFontSize
// フォントサイズを返す(どこのViewに適用するか、iPadかどうか)
func getFontSize(view: Views) -> Font {
    let isPad: Bool
    
    // iPadかどうか判定
    if Int(UIScreen.main.bounds.width) >= 700 {
        // iPad
        isPad = true
        
    } else {
        // iPhone
        isPad = false
        
    }
    
    switch view {
    case .settingView:
        // 通知画面
        if(isPad) {
            return Font.title
            
        } else {
            return Font.body
        }
        
    case .homeView:
        // ホーム画面
        if(isPad) {
            return Font.largeTitle
            
        } else {
            return Font.body
        }
        
    case .healthFaceView:
        // 体調表示
        if(isPad) {
            return Font.title
            
        } else {
            return Font.body
        }
        
    case .healthFaceDescriptionView:
        // 体調解説
        if(isPad) {
            return Font.largeTitle
            
        } else {
            return Font.title2
        }
    }
}

// MARK: - getFrameSize
func getFrameSize() -> (w: CGFloat, h: CGFloat) {
    // iPadかどうか判定
    if Int(UIScreen.main.bounds.width) >= 700 {
        // iPad
        return (150, 150)
        
    } else {
        // iPhone
        return (70, 70)
        
    }
}
