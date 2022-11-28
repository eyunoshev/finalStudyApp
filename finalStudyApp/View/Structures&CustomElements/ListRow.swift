//
//  ListRow.swift
//  finalStudyApp
//
//  Created by dunice on 23.11.2022.
//

import SwiftUI

//MARK: - Описание каждой ячейки

struct ListRow: View{
    
    @EnvironmentObject var otherProfileViewMpdel: OtherProfileViewMpdel
    @EnvironmentObject var mainMenuViewModel: MainMenuViewModel
    @EnvironmentObject var changeAndDeleteNewsViewModel: ChangeAndDeleteNewsViewModel
    @EnvironmentObject var myProfileViewModel: MyProfileViewModel
    
    @State var isPresentedAlert = false
    @State var eachNews: ContentNews
    
    @State var isActiveLinkOtherProfile: Bool = false
    @State var stateForChangeAndDeleteNews: Bool = false
    @State var stateForWrongAlertDelete: Bool = false
    
    var body: some View {
        
        VStack(spacing:20){
            HStack(){
                Text (eachNews.username)
                    .modifier(ModifierTextFromImagePicker())
                    .onTapGesture {
                        if eachNews.username != mainMenuViewModel.myProfile?.name {
                            otherProfileViewMpdel.takeTokenFromKeyChain {
                                otherProfileViewMpdel.getUserInfoById(userId: eachNews.userID){
                                    otherProfileViewMpdel.getUserNews(userID: eachNews.userID){
                                        isActiveLinkOtherProfile = true
                                    }
                                }
                            }
                        }
                    }
                Text ("Show his news")
                    .modifier(ModifierTextFromImagePicker())
                    .onTapGesture {
                        mainMenuViewModel.getUserNews(userID: eachNews.userID){}
                    }
            }
            Text (eachNews.title)
            Text (eachNews.contentDescription)
            
            MyAsyncImage(imageURL: eachNews.image)
                .frame(width: 200, height: 200, alignment: .center)
            Text ("id: \(eachNews.id)")
            
            HStack{
            Text("Change News")
                .modifier(ModifierTextFromImagePicker())
                .onTapGesture {
                    if eachNews.username == mainMenuViewModel.myProfile?.name {
                        changeAndDeleteNewsViewModel.takeNewsForChangeAndDelete(newsForChange: eachNews){
                            stateForChangeAndDeleteNews = true
                        }
                    }
                    else{
                        stateForWrongAlertDelete = true
                    }
                }
                
                Text("Delete News")
                    .modifier(ModifierTextFromImagePicker())
                    .onTapGesture {
                        if eachNews.username == mainMenuViewModel.myProfile?.name {
                            mainMenuViewModel.deleteMyNews(id: eachNews.id)
                            mainMenuViewModel.massiveNews.removeAll{ Item in
                                Item.id == eachNews.id
                            }
                            myProfileViewModel.massiveNews.removeAll{ Item in
                                Item.id == eachNews.id
                            }
                            mainMenuViewModel.getNews()
                        }
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
