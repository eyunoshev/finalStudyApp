//
//  SignUpView.swift
//  finalStudyApp
//
//  Created by dunice on 11.11.2022.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
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
                if signUpViewModel.imageURL == nil && name != "" && name.count > 5 && role != "" && role.count > 3 && email != "" && email.count > 10 && password != "" && password.count > 6{
                    signUpViewModel.uploadFile(image: image) {
                        signUpViewModel.register(avatar: signUpViewModel.imageURL ?? "", email: email, name: name, password: password, role: role) {
                            if signUpViewModel.myToken != "" {
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
            .modifier(ModifierTextFromImagePicker())
            .padding()
            .alert(isPresented: $stateForAlert) {
                Alert(title: Text("Регистрация"), message: Text("Успешна завершена"), dismissButton: Alert.Button.cancel())
            }
            .alert(isPresented: $stateForWrongAlert) {
                Alert(title: Text("Ошибка!"), message: Text("Заполнение полей name,email,role,password и выбор картинки был произведён неправильно! Выберите картинку, и заполните поля. В поле name минимум 6 символов, в поле email минимум 11 символов, в поле role минимум 4 символа, в поле password минимум 7 символов "), dismissButton: Alert.Button.cancel())
            }
        }
    }
}

