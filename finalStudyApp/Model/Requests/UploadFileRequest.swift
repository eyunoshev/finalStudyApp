//
//  UploadFileRequest.swift
//  finalStudyApp
//
//  Created by dunice on 25.11.2022.
//

import SwiftUI
import Alamofire

class UploadFile{
    
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
    
}
