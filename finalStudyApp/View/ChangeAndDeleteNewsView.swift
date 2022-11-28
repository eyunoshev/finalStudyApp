//
//  ChangeAndDeleteNewsView.swift
//  finalStudyApp
//
//  Created by dunice on 24.11.2022.
//

import SwiftUI

struct ChangeAndDeleteNewsView: View {
    
    @EnvironmentObject var changeAndDeleteNewsViewModel: ChangeAndDeleteNewsViewModel
    
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
            
            Text("Change news or Delete News")
            
            Text("Change photo")
                .modifier(ModifierTextFromImagePicker())
                .onTapGesture {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
            
            Image(uiImage: self.image)
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
                .modifier(ModifierImageFromImagePicker())
            
            
            
            HStack{
                Text("Title:")
                MyTextField(text: title, binding: $title)
            }
            HStack{
                Text("Description:")
                MyTextField(text: description, binding: $description)
            }
            HStack{
                Text("Tags:")
                MyTextField(text: tags, binding: $tags)
            }
            
            Button(action: {
                if description != "" && description.count > 6 && tags != "" && tags.count > 6 && title != "" && title.count > 6 && image != UIImage(){
                    tagss.removeAll()
                    tagss.append(tags)
                    changeAndDeleteNewsViewModel.uploadFile(image: image){
                        changeAndDeleteNewsViewModel.putNews(description: description, image: changeAndDeleteNewsViewModel.imageURL ?? "", tags: tagss, title: title, id: changeAndDeleteNewsViewModel.newsForChangeAndDelete?.id ?? 0)
                    }
                }
                else {
                    wrongAlert = true
                }
            }, label: {
                Text("Save Changes")
            })
            .alert(isPresented: $wrongAlert) {
                Alert(title: Text("Ошибка!"), message: Text("Заполните все поля (в каждом поле должно быть минимум 7 символов!!!) и выберите картинку новсти!"), dismissButton: Alert.Button.cancel())
            }
            .onAppear{
                changeAndDeleteNewsViewModel.takeTokenFromKeyChain {
                    changeAndDeleteNewsViewModel.load(url: URL(string: changeAndDeleteNewsViewModel.newsForChangeAndDelete?.image ?? "")!){ UIImage in
                        self.image = UIImage
                    }
                    title = changeAndDeleteNewsViewModel.newsForChangeAndDelete?.title ?? ""
                    description = changeAndDeleteNewsViewModel.newsForChangeAndDelete?.contentDescription ?? ""
                    tags = changeAndDeleteNewsViewModel.newsForChangeAndDelete?.tags[0].title ?? ""
                }
            }
        }
    }
}
