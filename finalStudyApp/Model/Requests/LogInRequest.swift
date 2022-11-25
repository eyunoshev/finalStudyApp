//
//  LogInRequest.swift
//  finalStudyApp
//
//  Created by dunice on 25.11.2022.
//

import SwiftUI

class LogIn{
    
    func logIn(email: String, password: String, onComplete: @escaping (SignIn) -> ()){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/auth/login") else { fatalError("Missing URL") }
        let parametrs = ["email": email, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: []) else { return }
        request.httpBody = httpBody
        let dataTask = URLSession.shared
        dataTask.dataTask(with: request) { (data, response, error) in
            if let response = response {
              print(response)
            }
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                   
                } catch let error {
                    print("Error encoding: ", error)
                }
            }
                do {
                    let decodedLogIn = try JSONDecoder().decode(SignIn.self, from: data)
                    DispatchQueue.main.async {
                        onComplete(decodedLogIn)
                    }
                }
                catch let error{
                    print("Erroe decoding", error)
                }
        }
        .resume()
    }
}
