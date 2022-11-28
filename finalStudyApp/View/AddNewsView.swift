//
//  AddNewsView.swift
//  finalStudyApp
//
//  Created by dunice on 16.11.2022.
//

import SwiftUI

struct AddNewsView: View {
    
    @EnvironmentObject var addNewsViewModel: AddNewsViewModel
    
    @State var description: String = ""
    @State var tags: String = ""
    @State var title: String = ""
    @State var tagss: [String] = [""]
    @State var wrongAlert: Bool = false
    
    //MARK: - Состояния для ImagePicker
    @State private var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        
        VStack{
            
        Text("Add news")
            .onAppear{
                addNewsViewModel.takeTokenFromKeyChain {}
            }
            
            HStack{
            Image(uiImage: self.image)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .modifier(ModifierImageFromImagePicker())
                
            Text("Choose photo")
                .modifier(ModifierTextFromImagePicker())
                .onTapGesture {
                    showSheet = true
                }
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showSheet) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            
            MyTextField(text: "Title", binding: $title)
            MyTextField(text: "Description", binding: $description)
            MyTextField(text: "Tags", binding: $tags)
            
            Button(action: {
                if description != "" && description.count > 6 && tags != "" && tags.count > 6 && title != "" && title.count > 6 && image != UIImage(){
                tagss.removeAll()
                tagss.append(tags)
                addNewsViewModel.createMyNews(image: image){
                    addNewsViewModel.newsRequests.postNews(description: description, image: addNewsViewModel.imageURLForAddNews ?? "", tags: tagss, title: title, myToken: addNewsViewModel.myToken!)
                }
                }
                else{
                    wrongAlert = true
                }
            }, label: {
                Text("Add news")
            })
            .modifier(ModifierTextFromImagePicker())
            .padding()
            .alert(isPresented: $wrongAlert) {
                Alert(title: Text("Ошибка!"), message: Text("Заполните все поля (в каждом поле должно быть минимум 7 символов!!!) и выберите картинку новсти!"), dismissButton: Alert.Button.cancel())
            }
    }
    }
}
