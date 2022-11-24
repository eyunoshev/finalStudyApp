//
//  ContentView.swift
//  finalStudyApp
//
//  Created by dunice on 11.11.2022.
//

import SwiftUI

//MARK: - View

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ViewModelNews
    
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
                if loginTextField != "" && passwordTextField != "" {
                    viewModel.logIn(email: loginTextField, password: passwordTextField){
                        viewModel.imageURL = viewModel.myProfile?.avatar
                        if viewModel.myToken != nil {
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
            .modifier(ModifierButton())
            
            
            Text("If you dont have account, create it")
            
            NavigationLink(
                destination: SignUpView(),
                label: {
                    Text("Sign Up")
                })
            
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
            Alert(title: Text("Ошибка!"), message: Text("Поля email и password не заполненны"), dismissButton: Alert.Button.cancel())
        }
        .navigationBarBackButtonHidden(true)
    }
}
