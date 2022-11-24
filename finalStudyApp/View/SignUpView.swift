//
//  SignUpView.swift
//  finalStudyApp
//
//  Created by dunice on 11.11.2022.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var viewModel: ViewModelNews
    
    @State var name: String = ""
    @State var email: String = ""
    @State var role: String = ""
    @State var password: String = ""
    
    //MARK: - Состояния для отображения алертов
    @State var stateForAlert: Bool = false
    @State var stateForWrongAlert: Bool = false
    
    //MARK: - Состояния для ImagePicker
    @State private var image = UIImage()
    @State private var showSheet = false
    
    
    
    
    var body: some View {
        VStack{
            HStack{
            Image(uiImage: self.image)
                    .resizable()
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
            Text("Введите свои данные")
            MyTextField(text: "name", binding: $name)
            MyTextField(text: "email", binding: $email)
            MyTextField(text: "password", binding: $password)
            MyTextField(text: "role", binding: $role)
            
            Button(action: {
                if viewModel.imageURL == nil && name != "" && role != "" && email != "" && password != ""{
                    viewModel.uploadFile(image: image) {
                        viewModel.register(avatar: viewModel.imageURL ?? "", email: email, name: name, password: password, role: role) {
                            if viewModel.myToken != "" {
                                stateForAlert = true
                            }
                        }
                    }
                }
                else {
                    stateForWrongAlert = true
                }
            }, label: {
                Text("Зарегистрироваться")
            })
            .alert(isPresented: $stateForAlert) {
                Alert(title: Text("Регистрация"), message: Text("Успешна завершена"), dismissButton: Alert.Button.cancel())
            }
            .alert(isPresented: $stateForWrongAlert) {
                Alert(title: Text("Ошибка!"), message: Text("Заполните все поля и выберите картинку профиля!"), dismissButton: Alert.Button.cancel())
            }
        }
    }
}

