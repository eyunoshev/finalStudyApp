//
//  MainMenuView.swift
//  finalStudyApp
//
//  Created by dunice on 14.11.2022.
//

import SwiftUI
import Foundation


struct MainMenuView: View {
    
    @EnvironmentObject var mainMenuViewModel: MainMenuViewModel
    
    @State private var image = UIImage()
    
    var body: some View {
        VStack{
            HStack(spacing: 40){
                NavigationLink(
                    destination: MyProfileView(),
                    label: {
                        
                        Image(uiImage: self.image)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .modifier(ModifierImageFromImagePicker())
                    })
                NavigationLink(
                    destination: AddNewsView(),
                    label: {
                        Text("Add News")
                    })
                    .modifier(ModifierTextFromImagePicker())
                Button(action: {
                    mainMenuViewModel.updateNews()
                }, label: {
                    Text("Show all News")
                })
                .modifier(ModifierTextFromImagePicker())
                .opacity((mainMenuViewModel.stateNewsForSwitchCase == 1) ? 0 : 1 )
                .onAppear{
                    mainMenuViewModel.takeTokenFromKeyChain {
                        mainMenuViewModel.getNews()
                        mainMenuViewModel.getUserInfo {
                            mainMenuViewModel.load(url: URL(string: mainMenuViewModel.myProfile?.avatar ?? "")!){ UIImage in
                                self.image = UIImage
                            }
                        }
                    }
                }
            }
            
            Button(action: {
                mainMenuViewModel.customAlertFindNews.alertTextField(title: "Find News", message: "Write author/keywords/tags for find news", hintText: "author", secondHintText: "keywords", thirdHintText: "tags", primaryTitle: "Find", secondaryTitle: "Clear") { (auth, keyw, tags) in
                    mainMenuViewModel.findNews(author: auth, keywords: keyw, tags: tags)
                } secondaryAction: {
                    mainMenuViewModel.updateNews()
                }
                
            }, label: {
                Text("Search News")
            })
            .modifier(ModifierTextFromImagePicker())
            .onAppear{
                mainMenuViewModel.updateNews()
            }
            
            switch mainMenuViewModel.stateNewsForSwitchCase{
            case 1:
                List(mainMenuViewModel.massiveNews){
                    Content in ListRow(eachNews: Content)
                        .onAppear {
                                      // Пагинация
                            if Content.id == mainMenuViewModel.massiveNews.last?.id{
                                mainMenuViewModel.addPaginate()
                                      }
                                    }
                }
                .padding()
            case 2:
                List(mainMenuViewModel.massiveNewsForFind){
                    Content in ListRow(eachNews: Content)
                }
            case 3:
                List(mainMenuViewModel.massiveNewsForUsersNews){
                    Content in ListRow(eachNews: Content)
                }
            default:
                EmptyView()
            }
        }
        .navigationBarHidden(true)
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
