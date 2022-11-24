//
//  ListRow.swift
//  finalStudyApp
//
//  Created by dunice on 23.11.2022.
//

import SwiftUI

//MARK: - Описание каждой ячейки

struct ListRow: View{
    
    @EnvironmentObject var viewModel: ViewModelNews
    
    @State var isPresentedAlert = false
    @State var eachNews: ContentNews
    
    @State var isActiveLinkOtherProfile: Bool = false
    @State var stateForChangeAndDeleteNews: Bool = false
    @State var stateForWrongAlertDelete: Bool = false
    
    var body: some View {
        
        VStack(spacing:20){
            HStack{
                Text ("author: \(eachNews.username)")
                    .modifier(ModifierText())
                    .onTapGesture {
                        if eachNews.username != viewModel.myProfile?.name {
                            viewModel.getUserInfoById(userId: eachNews.userID){
                                viewModel.getUserNews(userID: eachNews.userID){
                                    isActiveLinkOtherProfile = true
                                }
                            }
                        }
                    }
                Text ("Show Users News")
                    .modifier(ModifierText())
                    .onTapGesture {
                        viewModel.getUserNews(userID: eachNews.userID){}
                    }
            }
            Text (eachNews.title)
            Text (eachNews.contentDescription)
            
            MyAsyncImage(imageURL: eachNews.image)
                .frame(width: 200, height: 200, alignment: .center)
            Text ("id: \(eachNews.id)")
            
            HStack{
            Text("Change News")
                .modifier(ModifierText())
                .onTapGesture {
                    if eachNews.username == viewModel.myProfile?.name {
                        viewModel.takeNewsForChangeAndDelete(newsForChange: eachNews){
                            stateForChangeAndDeleteNews = true
                        }
                    }
                    else{
                        stateForWrongAlertDelete = true
                    }
                }
                
                Text("Delete News")
                    .modifier(ModifierText())
                    .onTapGesture {
                        if eachNews.username == viewModel.myProfile?.name {
                            viewModel.deleteMyNews(id: eachNews.id)                        }
                        else{
                            stateForWrongAlertDelete = true
                        }
                    }
            }
            
            NavigationLink(
                destination: OtherProfileView(),
                isActive: $isActiveLinkOtherProfile,
                label: {
                    EmptyView()
                })
                .frame(width: 0, height: 0)
                .hidden()
                
            NavigationLink(
                destination: ChangeAndDeleteNewsView(),
                isActive: $stateForChangeAndDeleteNews,
                label: {
                    EmptyView()
                })
                .frame(width: 0, height: 0)
                .hidden()
                
                .alert(isPresented: $stateForWrongAlertDelete) {
                    Alert(title: Text("Ошибка!"), message: Text("Вы можете удалять и изменять только свои новости!"), dismissButton: Alert.Button.cancel())
                }
        }
        .padding()
    }
}
