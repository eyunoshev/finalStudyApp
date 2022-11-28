//
//  OtherProfile.swift
//  finalStudyApp
//
//  Created by dunice on 24.11.2022.
//

import SwiftUI

struct OtherProfileView: View {
    
    @EnvironmentObject var otherProfileViewMpdel: OtherProfileViewMpdel
    
    @State var image = UIImage()
    
    
    var body: some View {
        
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .modifier(ModifierImageFromImagePicker())
            
            Text("Name: \(otherProfileViewMpdel.otherProfile?.name ?? "")")
            Text("Email: \(otherProfileViewMpdel.otherProfile?.email ?? "")")
            Text("Role: \(otherProfileViewMpdel.otherProfile?.role ?? "")")
                .onAppear{
                    otherProfileViewMpdel.load(url: URL(string: otherProfileViewMpdel.otherProfile?.avatar ?? "")!){ UIImage in
                        self.image = UIImage
                    }
                }
            List(otherProfileViewMpdel.massiveNews){
                Content in ListRow(eachNews: Content)
            }
            .padding()
        }
    }
}

