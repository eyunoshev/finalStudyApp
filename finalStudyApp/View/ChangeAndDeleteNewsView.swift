//
//  ChangeAndDeleteNewsView.swift
//  finalStudyApp
//
//  Created by dunice on 24.11.2022.
//

import SwiftUI

struct ChangeAndDeleteNewsView: View {
    
    @EnvironmentObject var viewModel: ViewModelNews
    
    @State var description: String = ""
    @State var tags: String = ""
    @State var title: String = ""
    @State var tagss: [String] = [""]
    
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
                tagss.removeAll()
                tagss.append(tags)
                viewModel.uploadFile(image: image){
                    viewModel.putNews(description: description, image: viewModel.imageURL ?? "", tags: tagss, title: title, id: viewModel.newsForChangeAndDelete?.id ?? 0)
                }
            }, label: {
                Text("Save Changes")
            })
            .onAppear{
                viewModel.load(url: URL(string: viewModel.newsForChangeAndDelete?.image ?? "")!){ UIImage in
                    self.image = UIImage
                }
                title = viewModel.newsForChangeAndDelete?.title ?? ""
                description = viewModel.newsForChangeAndDelete?.contentDescription ?? ""
                tags = viewModel.newsForChangeAndDelete?.tags[0].title ?? ""
            }
        }
    }
}
