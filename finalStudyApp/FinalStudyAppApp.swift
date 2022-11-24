//
//  finalStudyAppApp.swift
//  finalStudyApp
//
//  Created by dunice on 11.11.2022.
//

import SwiftUI

@main
struct FinalStudyAppApp: App {
    
    @StateObject var viewModel = ViewModelNews()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
            .environmentObject(viewModel)
        }
    }
}
