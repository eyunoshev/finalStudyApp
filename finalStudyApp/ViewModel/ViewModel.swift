//
//  ViewModel.swift
//  finalStudyApp
//
//  Created by dunice on 11.11.2022.
//

import Foundation
import SwiftUI

var mvvmNews = MvvmNews()

class ViewModelNews: ObservableObject{
    
    @Published var customAlertFindNews = CustomAlertFindNews()
    @Published var massiveNews = [ContentNews]()
    @Published var myProfile: DataRegister?
    @Published var myToken: String? = nil
    @Published var succesRegister: Bool = false
    @Published var stateNews: Int = 1
    @Published var imageURL: String?
    @Published var imageURLForAddNews: String?
    @Published var otherProfile: DataRegister?
    @Published var newsForChangeAndDelete: ContentNews?
    
    
    
    func deleteMyNews(id: Int) {
        mvvmNews.deleteNews(id: id, myToken: myToken!)
        updateNews()
    }
    
    func createMyNews(image: UIImage, onComplete: @escaping ()->()){
        mvvmNews.uploadFile(image: image) { (URLImage) in
            self.imageURLForAddNews = URLImage?.data
            onComplete()
        }
    }
    
    func putNews(description: String, image: String, tags: [String], title: String, id: Int){
        mvvmNews.putNews(description: description, image: image, tags: tags, title: title, id: id, myToken: myToken!)
        updateNews()
    }
    
    func logIn(email: String, password: String, onComplete: @escaping () -> ()) {
        mvvmNews.logIn(email: email, password: password) { GetNews in
            self.imageURL = GetNews.data.avatar
            self.myProfile = GetNews.data
            self.myToken = GetNews.data.token
            onComplete()
        }
        updateNews()
    }
    
    
    func register(avatar: String, email: String, name: String, password: String, role: String, onComplete: @escaping () ->()){
        mvvmNews.register(avatar: avatar, email: email, name: name, password: password, role: role) { (SignIn) in
            self.myToken = SignIn.data.token
            onComplete()
        }
    }
    
    func findNews(author: String, keywords: String, tags: [String]){
        massiveNews.removeAll()
        mvvmNews.findNews(author: author, keywords: keywords, tags: tags, myToken: myToken!) { (FIndNews) in
            self.massiveNews = FIndNews.content
        }
    }
    
    func getUserNews(userID: UUID, onComplete: @escaping () ->()){
        mvvmNews.getUsersNews(userId: userID, myToken: myToken!) { (GetNews) in
            self.massiveNews = GetNews.data.content
            onComplete()
        }
    }
    
    
    func updateNews(){
        massiveNews.removeAll()
        mvvmNews.getNews(){GetNews in
            self.massiveNews = GetNews.data.content
        }
    }
    
    func uploadFile(image: UIImage, onComplete: @escaping() -> ()){
        mvvmNews.uploadFile(image:image) { (URLImage) in
            self.imageURL = URLImage?.data
            onComplete()
        }
    }
    
    func replaceUser(avatar: String, email: String, name: String, role: String){
        mvvmNews.replaceUser(avatar: avatar, email: email, name: name, role: role, myToken: myToken!){ (DataRegister) in
            self.myProfile = DataRegister.data
            self.imageURL = DataRegister.data.avatar
        }
    }
    
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
    
    func getUserInfoById(userId: UUID, onComplete: @escaping () ->()){
        mvvmNews.getUserInfoById(userId: userId, myToken: myToken!){ SignIn in
            self.otherProfile = SignIn.data
            onComplete()
        }
    }
    
    func takeNewsForChangeAndDelete(newsForChange: ContentNews , onComplete: @escaping () -> ()){
        self.newsForChangeAndDelete = newsForChange
        onComplete()
    }
}
