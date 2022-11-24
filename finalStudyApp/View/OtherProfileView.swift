//
//  OtherProfile.swift
//  finalStudyApp
//
//  Created by dunice on 24.11.2022.
//

import SwiftUI

struct OtherProfileView: View {
    
    @EnvironmentObject var viewModel: ViewModelNews
    @State private var image = UIImage()
    
    var body: some View {
        
        VStack {
                Image(uiImage: self.image)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .modifier(ModifierImageFromImagePicker())
            
            Text("Name: \(viewModel.otherProfile?.name ?? "")")
            Text("Email: \(viewModel.otherProfile?.email ?? "")")
            Text("Role: \(viewModel.otherProfile?.role ?? "")")
            .onAppear{
                viewModel.load(url: URL(string: viewModel.otherProfile?.avatar ?? "")!){ UIImage in
                    self.image = UIImage
                }
            }
            List(viewModel.massiveNews){
                Content in ListRow(eachNews: Content)
            }
            .padding()
        }
    }
}

