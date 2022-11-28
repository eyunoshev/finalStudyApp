//
//  MainMenuViewModel.swift
//  finalStudyApp
//
//  Created by dunice on 28.11.2022.
//

import SwiftUI

class MainMenuViewModel: ObservableObject{
    
    var newsRequests = NewsRequests()
    var usersRequests = UserRequests()
    
    @Published var myProfile: DataRegister?
    @Published var customAlertFindNews = CustomAlertFindNews()
    @Published var massiveNewsForFind = [ContentNews]()
    @Published var stateNewsForSwitchCase: Int = 1
    @Published var myToken: String? = nil
    @Published var massiveNewsForUsersNews = [ContentNews]()
    @Published var pageForPaginate: Int = 1
    @Published var massiveNews = [ContentNews]()
    @Published var otherProfile: DataRegister?
    
    
    
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
    
    func findNews(author: String, keywords: String, tags: [String]){
        self.stateNewsForSwitchCase = 2
        massiveNewsForFind.removeAll()
        newsRequests.findNews(author: author, keywords: keywords, tags: tags, myToken: myToken!) { (FIndNews) in
            self.massiveNewsForFind = FIndNews.content
        }
    }
    
    func updateNews(){
        massiveNewsForFind.removeAll()
        massiveNewsForUsersNews.removeAll()
        self.pageForPaginate = 1
        self.stateNewsForSwitchCase = 1
        newsRequests.getNews(pageForPaginate: pageForPaginate){GetNews in
            self.massiveNews = GetNews.data.content
        }
    }
    
    func addPaginate(){
        self.pageForPaginate += 1
        newsRequests.getNews(pageForPaginate: pageForPaginate){ GetNews in
            self.massiveNews += GetNews.data.content
        }
    }
    
    func getUserInfo(onComplete: @escaping () -> ()){
            usersRequests.getUserInfo(myToken: myToken ?? ""){ SignIn in
                self.myProfile = SignIn.data
                onComplete()
            }
        }
    
    func getNews(){
        newsRequests.getNews(pageForPaginate: pageForPaginate){GetNews in
            self.massiveNews = GetNews.data.content
        }
    }
    
    func takeTokenFromKeyChain(onComplete: @escaping () -> ()){
        let data = KeychainHelper.standard.read(token: "access-token", account: "facebook") ?? Data()
        let accessToken = String(data: data, encoding: .utf8)!
        myToken = accessToken
        onComplete()
    }
    
    func getUserNews(userID: UUID, onComplete: @escaping () ->()){
        self.stateNewsForSwitchCase = 3
        newsRequests.getUsersNews(userId: userID, myToken: myToken ?? "") { (GetNews) in
            self.massiveNewsForUsersNews = GetNews.data.content
            onComplete()
        }
    }
    
    func getUserInfoById(userId: UUID, onComplete: @escaping () ->()){
        usersRequests.getUserInfoById(userId: userId, myToken: myToken ?? ""){ SignIn in
            self.otherProfile = SignIn.data
            onComplete()
        }
    }
    
    func deleteMyNews(id: Int) {
        newsRequests.deleteNews(id: id, myToken: myToken!)
    }
}
