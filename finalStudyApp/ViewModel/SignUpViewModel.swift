//
//  SignUpViewModel.swift
//  finalStudyApp
//
//  Created by dunice on 28.11.2022.
//

import SwiftUI

class SignUpViewModel: ObservableObject{
    
    var uploadFileRequest = UploadFile()
    var signInRequest = Register()
    
    @Published var imageURL: String?
    
    var myToken: String? = nil
    
    func uploadFile(image: UIImage, onComplete: @escaping() -> ()){
        uploadFileRequest.uploadFile(image:image) { (URLImage) in
            self.imageURL = URLImage?.data
            onComplete()
        }
    }
    
    func register(avatar: String, email: String, name: String, password: String, role: String, onComplete: @escaping () ->()){
        signInRequest.register(avatar: avatar, email: email, name: name, password: password, role: role) { (SignIn) in
            self.myToken = SignIn.data.token
            onComplete()
        }
    }
    
}
