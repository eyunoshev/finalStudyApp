//
//  NewsRequests.swift
//  finalStudyApp
//
//  Created by dunice on 25.11.2022.
//

import SwiftUI

class NewsRequests{

    func getNews(pageForPaginate: Int, onComplete: @escaping (GetNews) -> ()){
        
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/news?page=\(pageForPaginate)&perPage=10") else { fatalError("Missing URL") }
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
}
