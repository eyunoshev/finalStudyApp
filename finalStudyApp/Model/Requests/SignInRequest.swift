//
//  SignInRequest.swift
//  finalStudyApp
//
//  Created by dunice on 25.11.2022.
//

import SwiftUI

class Register {
    
    func register (avatar: String, email: String, name: String, password: String, role: String, onComplete: @escaping (SignIn) -> ()){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/auth/register") else { fatalError("Missing URL") }
        let parameters = ["avatar": avatar, "email": email, "name": name, "password": password, "role": role]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            catch{
                print("error")
            }
            do {
                let decodedRegister = try JSONDecoder().decode(SignIn.self, from: data)
                DispatchQueue.main.async {
                    onComplete(decodedRegister)
                }
            }
            catch let error{
                print("Erroe decoding", error)
            }
        }.resume()
    }
}
