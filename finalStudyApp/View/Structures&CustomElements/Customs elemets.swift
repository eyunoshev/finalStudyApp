//
//  Customs elemets.swift
//  finalStudyApp
//
//  Created by dunice on 23.11.2022.
//

import SwiftUI

//MARK: - Кастомный алерт для поиска новостей

class CustomAlertFindNews{
    
    
    func alertTextField(title: String, message: String, hintText: String, secondHintText: String, thirdHintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (_ author: String, _ keywords: String, _ tags: [String]) -> (), secondaryAction: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField{ field in
            field.placeholder = hintText
        }
        alert.addTextField{ field in
            field.placeholder = secondHintText
        }
        alert.addTextField{ field in
            field.placeholder = thirdHintText
        }
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { [self]_ in
            let textField1 = alert.textFields?[0]
            print("Text field: \(String(describing: textField1?.text))")
            let textField2 = alert.textFields?[1]
            print("Text field: \(String(describing: textField2?.text))")
            let textField3 = alert.textFields?[2]
            print("Text field: \(String(describing: textField3?.text))")
            
            let author = alert.textFields?[0].text ?? ""
            let keywords = alert.textFields?[1].text ?? ""
            let tag  = alert.textFields?[2].text ?? ""
            var tags :[String] = []
            tags.append(tag)
            
            
            
            primaryAction(author, keywords, tags)
        }
        ))
        
        alert.addAction(.init(title: secondaryTitle, style: .destructive, handler: { _ in
            secondaryAction()
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
    
    
    func rootController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

//MARK: - кастомный AsyncImage так как моя версия xcode не имеет такой штуки :(

struct MyAsyncImage: View {
    var imageURL: String
    @State var imageData: Data? = nil
    
    var body: some View {
        if let data = imageData {
            Image(uiImage: UIImage(data: data) ?? UIImage())
                .resizable()
                .scaledToFill()
        } else {
            Text("Loading...")
                .onAppear {
                    DispatchQueue.global().async {
                        URLSession.shared.dataTask(with: URL(string: imageURL)!){ (data,response,error)  in
                            guard let data = data else { return }
                            imageData = data
                        }
                        .resume()
                    }
                }
        }
    }
}

//MARK: - ну это чисто чтоб меньше повторяющегося кода )

struct MyTextField: View {
    var text: String
    var binding: Binding<String>
    var body: some View {
        TextField(text, text: binding)
            .textFieldStyle(OvalTextFieldStyle())
            .padding(.horizontal, 20)
    }
}
