//
//  UsersRequests.swift
//  finalStudyApp
//
//  Created by dunice on 25.11.2022.
//

import SwiftUI

class UserRequests{
    
    func replaceUser(avatar: String, email: String, name: String, role: String, myToken: String, onComplete: @escaping (SignIn)->()){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/user") else { fatalError("Missing URL") }
        let parametrs = ["avatar": avatar,
                         "email": email,
                         "name": name,
                         "role": role]
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue(myToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print (response)
            }
            
            guard let data = data  else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
            } catch {
                print(error)
            }
            do {
                let decodedProfile = try JSONDecoder().decode(SignIn.self, from: data)
                DispatchQueue.main.async {
                    onComplete(decodedProfile)
                }
            }
            catch let error{
                print("Erroe decoding", error)
            }
        }.resume()
    }
    
    
    func getUserInfoById(userId: UUID, myToken: String, onComplete: @escaping (SignIn) -> ()){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/user/\(userId)") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(myToken, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let data = data else { return }
                do {
                    let decodedProfileUser = try JSONDecoder().decode(SignIn.self, from: data)
                    DispatchQueue.main.async {
                        onComplete(decodedProfileUser)
                    }
                } catch let error {
                    print("Error decoding: ", error)
                }
        }
        dataTask.resume()
    }
    
    func getUserInfo(myToken: String, onComplete: @escaping (SignIn) -> ()){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/user/info") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(myToken, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let data = data else { return }
                do {
                    let decodedProfileUser = try JSONDecoder().decode(SignIn.self, from: data)
                    DispatchQueue.main.async {
                        onComplete(decodedProfileUser)
                    }
                } catch let error {
                    print("Error decoding: ", error)
                }
        }
        dataTask.resume()
    }
}
