//
//  modelRequest.swift
//  finalStudyApp
//
//  Created by dunice on 11.11.2022.
//

import Foundation
import SwiftUI
import Alamofire


class MvvmNews{
    

    func getNews(onComplete: @escaping (GetNews) -> ()){
        
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/news?page=1&perPage=10") else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let data = data else { return }
            do{
            let decodedNews = try JSONDecoder().decode(GetNews.self, from: data)
                DispatchQueue.main.async {
                    onComplete(decodedNews)
                }
            }
            catch{
                print(error)
            }
        }
        dataTask.resume()
    }
    
    
    func postNews(description: String, image: String, tags: [String], title: String, myToken: String){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/news") else { fatalError("Missing URL") }
        let parametrs = ["description": description,
                         "image": image,
                         "tags": tags,
                         "title": title] as [String : Any]
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
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
        }.resume()
    }
    
    
    func putNews(description: String, image: String, tags: [String], title: String, id: Int, myToken: String){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/news/\(id)") else { fatalError("Missing URL") }
        let parametrs = ["description": description,
                         "image": image,
                         "tags": tags,
                         "title": title] as [String : Any]
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
        }.resume()
    }
    
    
    func deleteNews(id: Int, myToken: String){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/news/\(id)") else { fatalError("Missing URL") }
        let parametrs = ["id":id]
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
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
        }.resume()
    }
    
    func strokeUrlForFindNews(author: String, keywords: String, tags: [String]) -> String{
        var url: String = "https://news-feed.dunice-testing.com/api/v1/news/find?page=1&perPage=5"
        if author != "" {
            url += "&author=\(author)"
        }
        if keywords != "" {
            url += "&keywords=\(keywords)"
        }
        if tags[0] != "" {
            url += "&tags=\(tags[0])"
        }
        return url
    }
    
    func findNews(author: String, keywords: String, tags: [String], myToken: String, onComplete: @escaping (FIndNews) -> ()){
        guard let url = URL(string: strokeUrlForFindNews(author: author, keywords: keywords, tags: tags)) else {
            fatalError("Missing URL") }
        var request = URLRequest(url: url)
        request.addValue(myToken, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let data = data else { return }
            
                do {
                    let decodedNews = try JSONDecoder().decode(FIndNews.self, from: data)
                    DispatchQueue.main.async {
                        onComplete(decodedNews)
                    }
                } catch let error {
                    print("Error decoding: ", error)
                }
        }
        dataTask.resume()
    }
    
    
    func getUsersNews(userId: UUID, myToken: String, onComplete: @escaping (GetNews) -> ()){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/news/user/\(userId)?page=1&perPage=5") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(myToken, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let data = data else { return }
                do {
                    let decodedNews = try JSONDecoder().decode(GetNews.self, from: data)
                    DispatchQueue.main.async {
                        onComplete(decodedNews)
                    }
                } catch let error {
                    print("Error decoding: ", error)
                }
        }
        dataTask.resume()
    }
    
    
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
    
    

    
    
    public func uploadFile(image: UIImage, onComplete: @escaping (URLImage?)->()){
        // Prepare URL
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/file/uploadFile") else { return }
        // Parse Image
        guard let imageData = image.pngData() else {
          print("postUploadFile: Error with image converting")
          return
        }
        // Data: returned structure
        var data: URLImage?
        // Perform HTTP Requests
          AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
          }, to: url, headers: nil)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: URLImage.self) { response in
              debugPrint(response)
              switch response.result {
              case .success:
                data = response.value
                onComplete(data)
              case .failure:
                print ("failure")
              }
            }
      }
    
    
    
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
    
}



