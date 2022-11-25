//
//  AddNewsView.swift
//  finalStudyApp
//
//  Created by dunice on 16.11.2022.
//

import SwiftUI

struct AddNewsView: View {
    
    @EnvironmentObject var viewModel: ViewModelNews
    
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
                if description != "" && tags != "" && title != "" && image != UIImage(){
                tagss.removeAll()
                tagss.append(tags)
                viewModel.createMyNews(image: image){
                    newsRequests.postNews(description: description, image: viewModel.imageURLForAddNews ?? "", tags: tagss, title: title, myToken: viewModel.myToken!)
                    viewModel.updateNews()}
                }
                else{
                    wrongAlert = true
                }
            }, label: {
                Text("Add news")
            })
            .alert(isPresented: $wrongAlert) {
                Alert(title: Text("Ошибка!"), message: Text("Заполните все поля и выберите картинку новсти!"), dismissButton: Alert.Button.cancel())
            }
    }
    }
}
