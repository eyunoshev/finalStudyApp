//
//  finalStudyAppApp.swift
//  finalStudyApp
//
//  Created by dunice on 11.11.2022.
//

import SwiftUI

@main
struct FinalStudyAppApp: App {
    
    @StateObject var otherProfileViewMpdel = OtherProfileViewMpdel()
    @StateObject var addNewsViewModel = AddNewsViewModel()
    @StateObject var contentViewModel = ContentViewModel()
    @StateObject var mainMenuViewModel = MainMenuViewModel()
    @StateObject var myProfileViewModel = MyProfileViewModel()
    @StateObject var signUpViewModel = SignUpViewModel()
    @StateObject var changeAndDeleteNewsViewModel = ChangeAndDeleteNewsViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
            .environmentObject(otherProfileViewMpdel)
            .environmentObject(addNewsViewModel)
            .environmentObject(contentViewModel)
            .environmentObject(mainMenuViewModel)
            .environmentObject(myProfileViewModel)
            .environmentObject(signUpViewModel)
            .environmentObject(changeAndDeleteNewsViewModel)
        }
    }
}
