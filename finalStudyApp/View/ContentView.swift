//
//  ContentView.swift
//  finalStudyApp
//
//  Created by dunice on 11.11.2022.
//

import SwiftUI

//MARK: - View

struct ContentView: View {
    
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    @State var loginTextField: String = ""
    @State var passwordTextField: String = ""
    @State var isActiveLinkMenu: Bool = false
    @State var stateForWrongAlert: Bool = false
    @State var stateForWrongLogIn: Bool = false
    
    
    var body: some View {
        
        VStack{
            Text("Email")
            MyTextField(text: "Email", binding: $loginTextField)
            Text("Password")
            MyTextField(text: "Password", binding: $passwordTextField)
            
            Button(action: {
                if loginTextField != "" && loginTextField.count > 10 && passwordTextField != "" && passwordTextField.count > 6 {
                    contentViewModel.logIn(email: loginTextField, password: passwordTextField){
                        contentViewModel.imageURL = contentViewModel.myProfile?.avatar
                        if contentViewModel.myToken != nil {
                            contentViewModel.saveToken(myToken: contentViewModel.myToken ?? "")
                            isActiveLinkMenu.toggle()
                        }
                    }
                }
                else {
                    stateForWrongAlert = true
                }
            }, label: {
                Text("Log In")
            })
            .onAppear{
                contentViewModel.takeTokenFromKeyChain{
                    if contentViewModel.myToken != nil && contentViewModel.myToken != "" {
                        contentViewModel.getUserInfo{
                            isActiveLinkMenu = true
                        }
                    }
                }
            }
            .modifier(ModifierTextFromImagePicker())
            .padding(.horizontal, 100)
            .padding(.bottom, 200)
            
            
            Text("If you dont have account, create it")
            
            NavigationLink(
                destination: SignUpView(),
                label: {
                    Text("Sign Up")
                })
                .modifier(ModifierTextFromImagePicker())
                .padding(.horizontal, 100)
            
            NavigationLink(
                destination: MainMenuView(),
                isActive: $isActiveLinkMenu,
                label: {
                    Text("")
                })
        }
        
//        .alert(isPresented: $stateForWrongLogIn) {
//            Alert(title: Text("Ошибка!"), message: Text("email или пароль не верны!"), dismissButton: Alert.Button.cancel())
//        }    не получается настроить поток , чтобы он дождался пока токен запишется , прежде чем выводить алерт, ну и не получается 2 аллерта вывести( 
        .alert(isPresented: $stateForWrongAlert) {
            Alert(title: Text("Ошибка!"), message: Text("Поля email и password заполненны не корректно: в полях email и password должно быть минимум по 8 символов "), dismissButton: Alert.Button.cancel())
        }
        .navigationBarBackButtonHidden(true)
    }
}
