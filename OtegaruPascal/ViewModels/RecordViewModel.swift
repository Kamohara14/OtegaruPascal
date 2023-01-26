//
//  RecordViewModel.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/10.
//

import Foundation
import SwiftUI

final class RecordViewModel: ObservableObject {
    // Model
    @Published private var recordManager = RecordManager.shared
    
    // 記録の配列
    @Published var recordArray: [Record] = []
    
    // 体調の評価(デフォルトは選択していない)
    @Published var evaluation: Int = 0
    
    // 選択されているボタン
    @Published var evaluationButton = (
        (Color("Text_MainColor"), Color("Button_Record")), // 4
        (Color("Text_MainColor"), Color("Button_Record")), // 3
        (Color("Text_MainColor"), Color("Button_Record")), // 2
        (Color("Text_MainColor"), Color("Button_Record"))  // 1
    )
    // 記録ボタンの表示の有無
    @Published var isSave: Bool = false
    
    // MARK: - init
    init() {
        // 記録を取ってくる
        recordArray = recordManager.getRecord()
    }
    
    // MARK: - addRecord
    // TODO: 記録の追加は1日に1回にする
    func addRecord() {
        // 配列に記録を追加する
        recordManager.addRecord(evaluation: evaluation)
        // 記録の更新
        recordArray = recordManager.getRecord()
        // 選択したボタンの初期化
        evaluationButton = (
            (Color("Text_MainColor"), Color("Button_Record")),
            (Color("Text_MainColor"), Color("Button_Record")),
            (Color("Text_MainColor"), Color("Button_Record")),
            (Color("Text_MainColor"), Color("Button_Record"))
        )
    }
    
    // MARK: - selectedButton
    // 選択されたボタンの処理
    func selectedButton(buttonNum: Evaluation) {
        switch buttonNum {
        case .Button4:
            // 良好
            evaluationButton = (
                (Color("Button_Record"), Color("Text_MainColor")),
                (Color("Text_MainColor"), Color("Button_Record")),
                (Color("Text_MainColor"), Color("Button_Record")),
                (Color("Text_MainColor"), Color("Button_Record"))
            )
            evaluation = 4
            break
            
        case .Button3:
            // 通常
            evaluationButton = (
                (Color("Text_MainColor"), Color("Button_Record")),
                (Color("Button_Record"), Color("Text_MainColor")),
                (Color("Text_MainColor"), Color("Button_Record")),
                (Color("Text_MainColor"), Color("Button_Record"))
            )
            evaluation = 3
            break
            
        case .Button2:
            // 良くない
            evaluationButton = (
                (Color("Text_MainColor"), Color("Button_Record")),
                (Color("Text_MainColor"), Color("Button_Record")),
                (Color("Button_Record"), Color("Text_MainColor")),
                (Color("Text_MainColor"), Color("Button_Record"))
            )
            evaluation = 2
            break
            
        case .Button1:
            // とても良くない
            evaluationButton = (
                (Color("Text_MainColor"), Color("Button_Record")),
                (Color("Text_MainColor"), Color("Button_Record")),
                (Color("Text_MainColor"), Color("Button_Record")),
                (Color("Button_Record"), Color("Text_MainColor"))
            )
            evaluation = 1
            break
        }
        
        // 選択し終わったらボタン表示
        isSave = true
    }
    
    // MARK: - deleteRecord
    func daleteRecord() {
        // 記録を削除
        recordManager.deleteRecord()
        // 記録を取ってくる
        recordArray = recordManager.getRecord()
    }
    
}


// MARK: - Evaluation
enum Evaluation {
    // ボタン
    case Button4
    case Button3
    case Button2
    case Button1
}
