//
//  SettingView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/09/30.
//

import SwiftUI

struct SettingView: View {
    // ViewModel
    @StateObject private var viewModel = SettingViewModel()
    
    // 通知の更新用
    @ObservedObject var mainViewModel: MainViewModel
    
    // Sheet用フラグ
    @State private var drugRegistrationSheet = false
    @State private var recordTimeSheet = false
    
    // Alert用フラグ
    @State private var notificationDeleteAlert = false
    
    var body: some View {
        ZStack {
            // 背景色
            Color("Background_NavigationView").ignoresSafeArea(edges: .top)
            Color("Background_App").ignoresSafeArea(edges: .bottom)
            
            VStack {
                
                Spacer()
                
                Form {
                    // MARK: - お薬情報
                    Section {
                        Toggle(isOn: $viewModel.isDrugNotification) {
                            Text("お薬情報の通知")
                                .foregroundColor(Color("Text_Black"))
                        }
                        
                        Button {
                            self.drugRegistrationSheet.toggle()
                            
                        } label: {
                            HStack {
                                Text("お薬の登録")
                                    .foregroundColor(Color("Text_Black"))
                                
                                Spacer()
                                
                                if viewModel.registeredDrug != "" {
                                    // お薬が登録されている
                                    Text("登録済み")
                                        .foregroundColor(Color("Text_Gray"))
                                    
                                } else {
                                    // お薬が登録されていない
                                    Text("未登録")
                                        .foregroundColor(Color("Text_Gray"))
                                }
                            }
                        }
                        .sheet(isPresented: $drugRegistrationSheet) {
                            DrugRegistrationView(viewModel: viewModel)
                        }
                        
                        
                    } header: {
                        Text("お薬情報")
                            .font(.subheadline)
                    }
                    
                    // MARK: - 体調記録
                    Section {
                        Toggle(isOn: $viewModel.isRecordNotification){
                            Text("体調記録の通知")
                                .foregroundColor(Color("Text_Black"))
                        }
                        Button {
                            self.recordTimeSheet.toggle()
                        } label: {
                            HStack {
                                Text("記録する時間")
                                    .foregroundColor(Color("Text_Black"))
                                Spacer()
                                Text("\(Int(viewModel.recordTime)) 時")
                                    .foregroundColor(Color("Text_Gray"))
                            }
                        }
                        .sheet(isPresented: $recordTimeSheet) {
                            RecordTimeView(viewModel: viewModel)
                        }
                        
                    } header: {
                        Text("体調記録")
                            .font(.subheadline)
                    }
                    
                    // MARK: - 通知
                    Section {
                        Button {
                            // アラート表示
                            self.notificationDeleteAlert = true
                            
                        } label: {
                            Text("通知削除")
                                .foregroundColor(Color("Text_Red"))
                        }
                        .alert("", isPresented: $notificationDeleteAlert) {
                            Button("削除", role: .destructive) {
                                // 通知の削除
                                viewModel.deleteNotification()
                            }
                        } message: {
                            Text("通知履歴が全て削除されます。よろしいですか?")
                        }
                        
                    } header: {
                        Text("通知")
                            .font(.subheadline)
                    }
                    
                } // Form
            } // VS
            .onDisappear {
                // 既読の反映
                mainViewModel.isRead()
            }
            
            
        }  // ZS
        
    } // body
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(mainViewModel: MainViewModel())
    }
}
