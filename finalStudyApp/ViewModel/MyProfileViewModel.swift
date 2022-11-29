//
//  MyProfileViewModel.swift
//  finalStudyApp
//
//  Created by dunice on 28.11.2022.
//

import SwiftUI

class MyProfileViewModel: ObservableObject{
    
    var uploadFileRequest = UploadFile()
    var usersRequests = UserRequests()
    var newsRequests = NewsRequests()
    
    @Published var imageURL: String?
    @Published var myProfile: DataRegister?
    @Published var massiveNews = [ContentNews]()
    
    var myToken: String? = nil
    var pageForPaginate: Int = 1
    
    
    func uploadFile(image: UIImage, onComplete: @escaping() -> ()){
        uploadFileRequest.uploadFile(image:image) { (URLImage) in
            self.imageURL = URLImage?.data
            onComplete()
        }
    }
    
    func replaceUser(avatar: String, email: String, name: String, role: String, myToken: String){
        usersRequests.replaceUser(avatar: avatar, email: email, name: name, role: role, myToken: myToken){ (DataRegister) in
            self.myProfile = DataRegister.data
            self.imageURL = DataRegister.data.avatar
        }
    }
    
    func deleteTokenFromKeyChain(onComplete: @escaping () ->()){
        KeychainHelper.standard.delete(token: "access-token", account: "facebook")
        onComplete()
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
    
    func getUserInfo(onComplete: @escaping () -> ()){
            usersRequests.getUserInfo(myToken: myToken ?? ""){ SignIn in
                self.myProfile = SignIn.data
                onComplete()
            }
        }
    
}
