//
//  MainMenuView.swift
//  finalStudyApp
//
//  Created by dunice on 14.11.2022.
//

import SwiftUI
import Foundation


struct MainMenuView: View {
    
    @EnvironmentObject var viewModel: ViewModelNews
    
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
                Button(action: {
                    viewModel.updateNews()
                }, label: {
                    Text("Show all News")
                })
                .onAppear{
                    viewModel.load(url: URL(string: viewModel.myProfile!.avatar)!){ UIImage in
                        self.image = UIImage
                    }
                }
                
            }
            
            Button(action: {
                viewModel.customAlertFindNews.alertTextField(title: "Find News", message: "Write author/keywords/tags for find news", hintText: "author", secondHintText: "keywords", thirdHintText: "tags", primaryTitle: "Find", secondaryTitle: "Clear") { (auth, keyw, tags) in
                    viewModel.findNews(author: auth, keywords: keyw, tags: tags)
                } secondaryAction: {
                    viewModel.updateNews()
                }
                
            }, label: {
                Text("Search News")
            })
            .onAppear{
                viewModel.updateNews()
            }
            
            
            List(viewModel.massiveNews){
                Content in ListRow(eachNews: Content)
            }
            .padding()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
