////
////  ViewModel.swift
////  finalStudyApp
////
////  Created by dunice on 11.11.2022.
////
//
//import Foundation
//import SwiftUI
//
//
//class ViewModelNews: ObservableObject{
//
//    var logInRequest = LogIn()
//    var signInRequest = Register()
//    var uploadFileRequest = UploadFile()
//    var newsRequests = NewsRequests()
//    var usersRequests = UserRequests()
//
////    @Published var customAlertFindNews = CustomAlertFindNews()
////    @Published var massiveNews = [ContentNews]()
////    @Published var massiveNewsForFind = [ContentNews]()
//    @Published var massiveNewsForUsersNews = [ContentNews]()
//    @Published var myProfile: DataRegister?
//    @Published var myToken: String? = nil
//    @Published var succesRegister: Bool = false
//    @Published var stateNews: Int = 1
////    @Published var pageForPaginate: Int = 1
//    @Published var stateNewsForSwitchCase: Int = 1
////    @Published var imageURL: String?
////    @Published var imageURLForAddNews: String?
//    @Published var otherProfile: DataRegister?
//    @Published var newsForChangeAndDelete: ContentNews?
//
//
////    func takeTokenFromKeyChain(onComplete: @escaping () -> ()){
////        let data = KeychainHelper.standard.read(token: "access-token", account: "facebook") ?? Data()
////        let accessToken = String(data: data, encoding: .utf8)!
////        myToken = accessToken
////        onComplete()
////    }
//
////    func deleteTokenFromKeyChain(onComplete: @escaping () ->()){
////        KeychainHelper.standard.delete(token: "access-token", account: "facebook")
////        onComplete()
////    }
//
////    func saveToken(myToken: String){
////        let data = Data(myToken.utf8)
////        KeychainHelper.standard.save(data, token: "access-token", account: "facebook")
////    }
//
//    func deleteMyNews(id: Int) {
//        newsRequests.deleteNews(id: id, myToken: myToken!)
//    }
//
////    func createMyNews(image: UIImage, onComplete: @escaping ()->()){
////        uploadFileRequest.uploadFile(image: image) { (URLImage) in
////            self.imageURLForAddNews = URLImage?.data
////            onComplete()
////        }
////    }
//
////    func putNews(description: String, image: String, tags: [String], title: String, id: Int){
////        newsRequests.putNews(description: description, image: image, tags: tags, title: title, id: id, myToken: myToken!)
////        updateNews()
////    }
//
////    func logIn(email: String, password: String, onComplete: @escaping () -> ()) {
////        logInRequest.logIn(email: email, password: password) { GetNews in
////            self.imageURL = GetNews.data.avatar
////            self.myProfile = GetNews.data
////            self.myToken = GetNews.data.token
////            onComplete()
////        }
////        updateNews()
////    }
//
//
////    func register(avatar: String, email: String, name: String, password: String, role: String, onComplete: @escaping () ->()){
////        signInRequest.register(avatar: avatar, email: email, name: name, password: password, role: role) { (SignIn) in
////            self.myToken = SignIn.data.token
////            onComplete()
////        }
////    }
//
////    func findNews(author: String, keywords: String, tags: [String]){
////        self.stateNewsForSwitchCase = 2
////        massiveNewsForFind.removeAll()
////        newsRequests.findNews(author: author, keywords: keywords, tags: tags, myToken: myToken!) { (FIndNews) in
////            self.massiveNewsForFind = FIndNews.content
////        }
////    }
//
////    func getUserNews(userID: UUID, onComplete: @escaping () ->()){
////        self.stateNewsForSwitchCase = 3
////        newsRequests.getUsersNews(userId: userID, myToken: myToken!) { (GetNews) in
////            self.massiveNewsForUsersNews = GetNews.data.content
////            onComplete()
////        }
////    }
//
//
////    func updateNews(){
////        massiveNewsForFind.removeAll()
////        massiveNewsForUsersNews.removeAll()
////        self.pageForPaginate = 1
////        self.stateNewsForSwitchCase = 1
////        newsRequests.getNews(pageForPaginate: pageForPaginate){GetNews in
////            self.massiveNews = GetNews.data.content
////        }
////    }
//
////    func uploadFile(image: UIImage, onComplete: @escaping() -> ()){
////        uploadFileRequest.uploadFile(image:image) { (URLImage) in
////            self.imageURL = URLImage?.data
////            onComplete()
////        }
////    }
//
////    func replaceUser(avatar: String, email: String, name: String, role: String){
////        usersRequests.replaceUser(avatar: avatar, email: email, name: name, role: role, myToken: myToken!){ (DataRegister) in
////            self.myProfile = DataRegister.data
////            self.imageURL = DataRegister.data.avatar
////        }
////    }
//
////    func load(url: URL, onComplete: @escaping (UIImage) -> ()) {
////        DispatchQueue.global().async {
////            if let data = try? Data(contentsOf: url) {
////                if let image = UIImage(data: data) {
////                    DispatchQueue.main.async {
////                        onComplete(image)
////                    }
////                }
////            }
////        }
////    }
//
////    func getUserInfoById(userId: UUID, onComplete: @escaping () ->()){
////        usersRequests.getUserInfoById(userId: userId, myToken: myToken!){ SignIn in
////            self.otherProfile = SignIn.data
////            onComplete()
////        }
////    }
//
////    func takeNewsForChangeAndDelete(newsForChange: ContentNews , onComplete: @escaping () -> ()){
////        self.newsForChangeAndDelete = newsForChange
////        onComplete()
////    }
//
////    func addPaginate(){
////        self.pageForPaginate += 1
////        newsRequests.getNews(pageForPaginate: pageForPaginate){ GetNews in
////            self.massiveNews += GetNews.data.content
////        }
////    }
//
////    func getUserInfo(onComplete: @escaping () -> ()){
////        usersRequests.getUserInfo(myToken: myToken ?? ""){ SignIn in
////            self.myProfile = SignIn.data
////            onComplete()
////        }
////    }
//}
