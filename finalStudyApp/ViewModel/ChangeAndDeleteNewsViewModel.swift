//
//  ChangeAndDeleteNewsViewModel.swift
//  finalStudyApp
//
//  Created by dunice on 28.11.2022.
//

import SwiftUI

class ChangeAndDeleteNewsViewModel: ObservableObject{
    
    var newsRequests = NewsRequests()
    var uploadFileRequest = UploadFile()
    
    @Published var imageURL: String?
    @Published var myToken: String? = nil
    @Published var newsForChangeAndDelete: ContentNews?
    
    func uploadFile(image: UIImage, onComplete: @escaping() -> ()){
        uploadFileRequest.uploadFile(image:image) { (URLImage) in
            self.imageURL = URLImage?.data
            onComplete()
        }
    }
    
    func putNews(description: String, image: String, tags: [String], title: String, id: Int){
        newsRequests.putNews(description: description, image: image, tags: tags, title: title, id: id, myToken: myToken ?? "")
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
    
    func takeNewsForChangeAndDelete(newsForChange: ContentNews , onComplete: @escaping () -> ()){
        self.newsForChangeAndDelete = newsForChange
        onComplete()
    }
    
    func takeTokenFromKeyChain(onComplete: @escaping () -> ()){
        let data = KeychainHelper.standard.read(token: "access-token", account: "facebook") ?? Data()
        let accessToken = String(data: data, encoding: .utf8)!
        myToken = accessToken
        onComplete()
    }
}
