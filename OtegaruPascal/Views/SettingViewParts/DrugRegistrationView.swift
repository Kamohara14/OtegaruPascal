//
//  DrugRegistrationView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/12/14.
//

import SwiftUI

struct DrugRegistrationView: View {
    // View用の画面を閉じるdismissハンドラ
    @Environment(\.dismiss) var dismiss
    // ViewModel
    @ObservedObject var viewModel: SettingViewModel
    // テキストの大きさ
    private let fontSize: Font
    
    // 登録するお薬の名前
    @State var name: String = ""
    
    // 削除ボタンを押したときのアラート
    @State var showingDeleteAlert = false
    // 削除ボタン以外のアラート
    @State var showingAlert = false
    
    // アラートに表示するメッセージ
    @State var message: String = ""
    
    // MARK: - init
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        self.fontSize = getFontSize(view: .settingView)
    }
    
    var body: some View {
        ZStack {
            // 設定画面の背景色に合わせる
            Color(red: 242/255, green: 242/255, blue: 247/255).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // MARK: - タイトル
                Text("お薬登録")
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                    .padding()
                
                // MARK: - 登録されているお薬の表示
                if viewModel.registeredDrug != "" {
                    Text("登録されているお薬「\(viewModel.registeredDrug)」")
                        .foregroundColor(Color("Text_Black"))
                        .font(fontSize)
                        .padding()
                    
                }
                
                // MARK: - 名前を入力
                TextField("お薬の名前", text: $name)
                    .foregroundColor(Color("Text_Black"))
                    .font(fontSize)
                    .frame(width: UIScreen.main.bounds.width / 1.3)
                    .padding()
                    .background(Color.white)
                    .padding()
                
                HStack(spacing: 80) {
                    // MARK: - 削除ボタン
                    Button {
                        // アラート表示
                        message = "「\(viewModel.registeredDrug)」が削除されます。\nよろしいですか？"
                        showingDeleteAlert = true
                        
                    } label: {
                        Text("削除")
                            .foregroundColor(Color("Text_White"))
                            .font(fontSize)
                            .padding(10)
                            .background(
                                Rectangle()
                                    .fill(viewModel.registeredDrug == "" ? Color.gray : Color.red)
                                    .cornerRadius(10)
                            )
                    } // Button
                    // お薬が登録されていないときは押せなくする
                    .disabled(viewModel.registeredDrug == "")
                    // 表示するアラート
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(title: Text("警告"),
                              message: Text(message),
                              primaryButton: .cancel(Text("キャンセル")),
                              secondaryButton: .destructive(Text("削除"),
                                                            action : {
                            // お薬情報を削除する
                            viewModel.deleteRegisteredDrug()
                            
                        }))
                    }
                    
                    // MARK: - 登録ボタン
                    Button {
                        // スペースを取り除く
                        name = name.trimmingCharacters(in: .whitespaces)
                        // 名前が入っているか確認
                        if name != "" && name.count < 10 {
                            viewModel.registeredDrug = name
                            message = "「\(name)」として登録されました"
                            
                        } else if name == "" {
                            message = "お薬の名前を入力してください"
                            
                        } else if name.count >= 10 {
                            message = "お薬の名前は9文字以内に収めてください"
                            
                        } else {
                            message = "エラー"
                            
                        }
                        // アラート表示
                        showingAlert = true
                        
                    } label: {
                        Text("登録")
                            .foregroundColor(Color("Text_White"))
                            .font(fontSize)
                            .padding(10)
                            .background(
                                Rectangle()
                                    .fill(Color.green)
                                    .cornerRadius(10)
                            )
                    } // Button
                    // 表示するアラート
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(message))
                    }
                    
                } // HS
                
                Spacer()
                Spacer()
                
                // MARK: - 戻るボタン
                Button{
                    dismiss()
                } label: {
                    Text("もどる")
                        .font(fontSize)
                        .foregroundColor(Color("Text_White"))
                        .frame(width: UIScreen.main.bounds.width / 1.3)
                        .padding()
                        .background(
                            Rectangle()
                                .fill(Color.blue)
                                .cornerRadius(20)
                        )
                } // Button
                .padding(.bottom, 15.0)
                
            } // VS
        } // ZS
    }
}

struct DrugRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        DrugRegistrationView(viewModel: SettingViewModel())
    }
}
