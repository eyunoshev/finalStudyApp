//
//  MyProfileView.swift
//  finalStudyApp
//
//  Created by dunice on 16.11.2022.
//

import SwiftUI

struct MyProfileView: View {
    
    @EnvironmentObject var viewModel: ViewModelNews
    
    @State var isActiveNav: Bool = false
    @State private var image = UIImage()
    @State private var showSheet = false
    
    @State var name: String = ""
    @State var email: String = ""
    @State var role: String = ""
    
    var body: some View {
        
        VStack {
            HStack {
                
                Image(uiImage: self.image)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .modifier(ModifierImageFromImagePicker())
                
                Text("Change photo")
                    .modifier(ModifierTextFromImagePicker())
                    .onTapGesture {
                        showSheet = true
                    }
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            HStack{
                Text("Name:")
                MyTextField(text: viewModel.myProfile?.name ?? "", binding: $name)
            }
            HStack{
                Text("Email:")
                MyTextField(text: viewModel.myProfile?.email ?? "", binding: $email)
            }
            HStack{
                Text("Role:")
                MyTextField(text: viewModel.myProfile?.role ?? "", binding: $role)
            }
            
            Button {
                if name != "" && email != "" && role != "" && image != nil {
                    viewModel.uploadFile(image: image){
                        viewModel.replaceUser(avatar: viewModel.imageURL ?? "" , email: email, name: name, role: role)
                    }
                }
            } label: {
                Text("Save changes")
            }
            
            
            Button(action: {
                viewModel.myProfile?.token?.removeAll()
                viewModel.deleteTokenFromKeyChain(){
                    isActiveNav.toggle()
                }
            }, label: {
                Text("Log out")
            })
            .padding()
            .onAppear{
                viewModel.load(url: URL(string: viewModel.myProfile!.avatar)!){ UIImage in
                    self.image = UIImage
                }
                name = viewModel.myProfile?.name ?? ""
                email = viewModel.myProfile?.email ?? ""
                role = viewModel.myProfile?.role ?? ""
            }
            
            List(viewModel.massiveNews.filter{ $0.username == viewModel.myProfile?.name}){
                Content in ListRow(eachNews: Content)
            }
            .padding()
            
        }
        .onAppear{
            viewModel.updateNews()
        }
        NavigationLink(
            destination: ContentView(),
            isActive: $isActiveNav,
            label: {
                Text("")
            })
    }
}
