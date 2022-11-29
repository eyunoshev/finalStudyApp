//
//  finalStudyAppTests.swift
//  finalStudyAppTests
//
//  Created by dunice on 28.11.2022.
//

import XCTest
@testable import finalStudyApp

class finalStudyAppTests: XCTestCase {
    
    var myProfileViewModel: MyProfileViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        myProfileViewModel = MyProfileViewModel()
        myProfileViewModel.myProfile = DataRegister(avatar: "FirstPictures", email: "Ivan@mail.ru", id: "first id", name: "IvanIvan", role: "User", token: "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJlMmUwZTNhZi0wN2RkLTRkZTEtODM0ZS01MGU2ODRjZTkwNWEiLCJleHAiOjE2NzA5NzYwMDB9.aSAHsxsIbEuB7ZuZHlRTHXitOMx8PMCKY4EQM5nbMtKDbBmzEWr0ilHMH8C5Btk9Pjhy8WVZjq6ztWYv4SbIiw")
        
        
    }

    override func tearDownWithError() throws {
        myProfileViewModel = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        
        myProfileViewModel.replaceUser(avatar: "SecondPictures", email: "Igor@mail.ru", name: "IgorIgor", role: "Admin", myToken: "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJlMmUwZTNhZi0wN2RkLTRkZTEtODM0ZS01MGU2ODRjZTkwNWEiLCJleHAiOjE2NzA5NzYwMDB9.aSAHsxsIbEuB7ZuZHlRTHXitOMx8PMCKY4EQM5nbMtKDbBmzEWr0ilHMH8C5Btk9Pjhy8WVZjq6ztWYv4SbIiw" )
        myProfileViewModel.usersRequests.replaceUser(avatar: "SecondPictures", email: "Igor@mail.ru", name: "IgorIgor", role: "Admin", myToken: "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJlMmUwZTNhZi0wN2RkLTRkZTEtODM0ZS01MGU2ODRjZTkwNWEiLCJleHAiOjE2NzA5NzYwMDB9.aSAHsxsIbEuB7ZuZHlRTHXitOMx8PMCKY4EQM5nbMtKDbBmzEWr0ilHMH8C5Btk9Pjhy8WVZjq6ztWYv4SbIiw"){ (DataRegister) in
            self.myProfileViewModel?.myProfile? = DataRegister.data
            self.myProfileViewModel?.imageURL? = DataRegister.data.avatar
            XCTAssertEqual(DataRegister.data.avatar , "SecondPictures")
            XCTAssertEqual(DataRegister.data.name , "IgorIgor")
            XCTAssertEqual(DataRegister.data.email , "Igor@mail.ru")
            XCTAssertEqual(DataRegister.data.role , "Admin")
        }
        
        
//        XCTAssertEqual(myProfileViewModel.myProfile?.avatar , "SecondPictures")
//        XCTAssertEqual(myProfileViewModel.myProfile?.name , "IgorIgor")
//        XCTAssertEqual(myProfileViewModel.myProfile?.email , "Igor@mail.ru")
//        XCTAssertEqual(myProfileViewModel.myProfile?.role , "Admin")
        
        
    }

    func testPerformanceExample() throws {
        measure {
        }
    }

}
