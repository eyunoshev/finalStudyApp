//
//  Modifiers.swift
//  finalStudyApp
//
//  Created by dunice on 23.11.2022.
//

import SwiftUI

//MARK: - Modifiers

struct ModifierTextField: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .accentColor(.blue)
            .foregroundColor(.blue)
    }
}

struct ModifierText: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .accentColor(.blue)
            .foregroundColor(.blue)
    }
}


struct ModifierButton: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.blue)
    }
}

struct ModifierImageFromImagePicker: ViewModifier{
    func body(content: Content) -> some View {
        content
            .cornerRadius(50)
            .padding(.all, 4)
            .frame(width: 100, height: 100)
            .background(Color.black.opacity(0.2))
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .padding(8)
    }
}

struct ModifierTextFromImagePicker: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(16)
            .foregroundColor(.white)
    }
}
