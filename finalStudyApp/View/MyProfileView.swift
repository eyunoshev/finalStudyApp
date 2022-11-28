//
//  MyProfileView.swift
//  finalStudyApp
//
//  Created by dunice on 16.11.2022.
//

import SwiftUI

struct MyProfileView: View {
    
    @EnvironmentObject var myProfileViewModel: MyProfileViewModel
    
    @State var isActiveNav: Bool = false
    @State private var image = UIImage()
    @State private var showSheet = false
    @State var wrongAlert: Bool = false
    
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
                Text("  Name:   ")
                MyTextField(text: myProfileViewModel.myProfile?.name ?? "", binding: $name)
            }
            .padding(.bottom, 5)
            HStack{
                Text("  Email:  ")
                MyTextField(text: myProfileViewModel.myProfile?.email ?? "", binding: $email)
            }
            .padding(.bottom, 5)
            HStack{
                Text("  Role:   ")
                MyTextField(text: myProfileViewModel.myProfile?.role ?? "", binding: $role)
            }
            .padding(.bottom, 5)
            
            Button {
                if name != "" && name.count > 5 && email != "" && email.count > 10 && role != "" && role.count > 3 && image != nil {
                    myProfileViewModel.uploadFile(image: image){
                        myProfileViewModel.replaceUser(avatar: myProfileViewModel.imageURL ?? "" , email: email, name: name, role: role)
                    }
                }
                else {
                    wrongAlert = true
                }
            } label: {
                Text("Save changes")
            }
            .modifier(ModifierTextFromImagePicker())
            .padding(.horizontal, 70)
            .padding(.bottom, 5)
            .alert(isPresented: $wrongAlert) {
                Alert(title: Text("Ошибка!"), message: Text("Заполнение полей name,email,role и выбор картинки был произведён неправильно! Выберите картинку, и заполните поля. В поле name минимум 6 символов, в поле email минимум 11 символов, в поле role минимум 4 символа "), dismissButton: Alert.Button.cancel())
            }
            
            
            Button(action: {
                myProfileViewModel.myProfile?.token?.removeAll()
                myProfileViewModel.deleteTokenFromKeyChain(){
                    isActiveNav.toggle()
                }
            }, label: {
                Text("Log out")
            })
            .modifier(ModifierTextFromImagePicker())
            .padding(.horizontal, 70)
            .onAppear{
                myProfileViewModel.takeTokenFromKeyChain {
                    myProfileViewModel.getUserInfo {
                        myProfileViewModel.load(url: URL(string: myProfileViewModel.myProfile!.avatar)!){ UIImage in
                            self.image = UIImage
                        }
                        name = myProfileViewModel.myProfile?.name ?? ""
                        email = myProfileViewModel.myProfile?.email ?? ""
                        role = myProfileViewModel.myProfile?.role ?? ""
                    }
                }
            }
            
            List(myProfileViewModel.massiveNews.filter{ $0.username == myProfileViewModel.myProfile?.name}){
                Content in ListRow(eachNews: Content)
            }
            .padding()
            
        }
        .onAppear{
            myProfileViewModel.getNews()
        }
        NavigationLink(
            destination: ContentView(),
            isActive: $isActiveNav,
            label: {
                Text("")
            })
            .navigationBarHidden(false)
    }
}
