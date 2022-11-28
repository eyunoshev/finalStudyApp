//
//  AddNewsViewModel.swift
//  finalStudyApp
//
//  Created by dunice on 28.11.2022.
//

import SwiftUI

class AddNewsViewModel: ObservableObject {
    
    var uploadFileRequest = UploadFile()
    var newsRequests = NewsRequests()
    
    @Published var imageURLForAddNews: String?
    @Published var myToken: String? = nil
    
    func createMyNews(image: UIImage, onComplete: @escaping ()->()){
        uploadFileRequest.uploadFile(image: image) { (URLImage) in
            self.imageURLForAddNews = URLImage?.data
            onComplete()
        }
    }
    
    func takeTokenFromKeyChain(onComplete: @escaping () -> ()){
        let data = KeychainHelper.standard.read(token: "access-token", account: "facebook") ?? Data()
        let accessToken = String(data: data, encoding: .utf8)!
        myToken = accessToken
        onComplete()
    }
    
}
