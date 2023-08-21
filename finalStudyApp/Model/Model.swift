//
//  model.swift
//  finalStudyApp
//
//  Created by dunice on 11.11.2022.
//

import Foundation

// MARK: - GetNews
struct GetNews: Codable {
    let data: DataClass
    let statusCode: Int
    let success: Bool
}

// MARK: - DataClass
struct DataClass: Codable {
    let content: [ContentNews]
    let numberOfElements: Int
}

// MARK: - Content
struct ContentNews: Codable, Identifiable {
    let contentDescription: String
    let id: Int
    let image: String
    let tags: [Tag]
    let title, username: String
    let userID: UUID

    enum CodingKeys: String, CodingKey {
        case contentDescription = "description"
        case id, image, tags, title
        case userID = "userId"
        case username
    }
}

// MARK: - Tag
struct Tag: Codable {
    let id: Int
    let title: String
}





// MARK: - Register
struct SignIn: Codable {
    let data: DataRegister?
    let statusCode: Int
    let success: Int
}

// MARK: - DataClass
struct DataRegister: Codable {
    var avatar, email, id, name: String
    var role: String
    var token: String?
}


// MARK: - FIndNews
struct FIndNews: Codable {
    let content: [ContentNews]
    let numberOfElements: Int
}

struct URLImage: Codable {
    let data: String
    let statusCode: Int
    let success: Bool
}


