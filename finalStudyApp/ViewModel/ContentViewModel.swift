//
//  ContentViewModel.swift
//  finalStudyApp
//
//  Created by dunice on 28.11.2022.
//

import SwiftUI

class ContentViewModel: ObservableObject{
    
    var logInRequest = LogIn()
    var usersRequests = UserRequests()
    
    @Published var imageURL: String?
    @Published var myProfile: DataRegister?
    @Published var myToken: String? = nil
    
    func logIn(email: String, password: String, onComplete: @escaping () -> ()) {
        logInRequest.logIn(email: email, password: password) { GetNews in
            self.imageURL = GetNews.data.avatar
            self.myProfile = GetNews.data
            self.myToken = GetNews.data.token
            onComplete()
        }
    }
    
    func saveToken(myToken: String){
        let data = Data(myToken.utf8)
        KeychainHelper.standard.save(data, token: "access-token", account: "facebook")
    }
    
    func takeTokenFromKeyChain(onComplete: @escaping () -> ()){
        let data = KeychainHelper.standard.read(token: "access-token", account: "facebook") ?? Data()
        let accessToken = String(data: data, encoding: .utf8)!
        myToken = accessToken
        onComplete()
    }
    
    func getUserInfo(onComplete: @escaping () -> ()){
        usersRequests.getUserInfo(myToken: myToken ?? ""){ SignIn in
            self.myProfile = SignIn.data
            onComplete()
        }
    }
}
