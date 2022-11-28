//
//  OtherProfileViewModel.swift
//  finalStudyApp
//
//  Created by dunice on 28.11.2022.
//

import SwiftUI

class OtherProfileViewMpdel: ObservableObject{
    
    var newsRequests = NewsRequests()
    var usersRequests = UserRequests()
    
    @Published var otherProfile: DataRegister?
    @Published var massiveNews = [ContentNews]()
    @Published var myToken: String? = nil
    
    func load(url: URL, onComplete: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        onComplete(image)
                    }
                }
            }
        }
    }
    
    func takeTokenFromKeyChain(onComplete: @escaping () -> ()){
        let data = KeychainHelper.standard.read(token: "access-token", account: "facebook") ?? Data()
        let accessToken = String(data: data, encoding: .utf8)!
        myToken = accessToken
        onComplete()
    }
    
    func getUserNews(userID: UUID, onComplete: @escaping () ->()){
        newsRequests.getUsersNews(userId: userID, myToken: myToken!) { (GetNews) in
            self.massiveNews = GetNews.data.content
            onComplete()
        }
    }
    
    func getUserInfoById(userId: UUID, onComplete: @escaping () ->()){
            usersRequests.getUserInfoById(userId: userId, myToken: myToken!){ SignIn in
                self.otherProfile = SignIn.data
                onComplete()
            }
        }
    
}
