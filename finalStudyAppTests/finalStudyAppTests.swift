//
//  finalStudyAppTests.swift
//  finalStudyAppTests
//
//  Created by dunice on 28.11.2022.
//

import XCTest
@testable import finalStudyApp

class finalStudyAppTests: XCTestCase {
    var mainMenuViewModel: MainMenuViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        
        mainMenuViewModel = MainMenuViewModel()
        mainMenuViewModel.myToken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJlMmUwZTNhZi0wN2RkLTRkZTEtODM0ZS01MGU2ODRjZTkwNWEiLCJleHAiOjE2NzA5NzYwMDB9.aSAHsxsIbEuB7ZuZHlRTHXitOMx8PMCKY4EQM5nbMtKDbBmzEWr0ilHMH8C5Btk9Pjhy8WVZjq6ztWYv4SbIiw"
  
    }

    override func tearDownWithError() throws {
        mainMenuViewModel = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        
        mainMenuViewModel.stateNewsForSwitchCase = 1
        
        mainMenuViewModel.findNews(author: "", keywords: "", tags: [""])
        
        XCTAssertEqual(mainMenuViewModel.stateNewsForSwitchCase, 2)
        
        mainMenuViewModel.updateNews()
        
        XCTAssertEqual(mainMenuViewModel.stateNewsForSwitchCase, 1)
        
        mainMenuViewModel.getUserNews(userID: UUID()){}
        XCTAssertEqual(self.mainMenuViewModel.stateNewsForSwitchCase, 3)
    }

    func testPerformanceExample() throws {
        measure {
        }
    }

}


class AddNewsViewModelTests: XCTestCase {
    
    var viewModel: AddNewsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AddNewsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testCreateMyNews() {
        guard let image = UIImage(named: "testImage") else { return }
        let expectation = XCTestExpectation(description: "Create news completion called")
        
        viewModel.createMyNews(image: image) {
            XCTAssertEqual(self.viewModel.imageURLForAddNews, "ExpectedURLString", "Incorrect URL for added news")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testTakeTokenFromKeyChain() {
        let expectation = XCTestExpectation(description: "Take token completion called")
        
        viewModel.takeTokenFromKeyChain {
            XCTAssertEqual(self.viewModel.myToken, "ExpectedAccessToken", "Incorrect access token from Keychain")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testTakeTokenFromKeyChain_WhenKeychainReturnsNilData() {
        let expectation = XCTestExpectation(description: "Take token completion called")
        
        saveNilTokenToKeychain() // Сохранить пустые данные в Keychain
        
        viewModel.takeTokenFromKeyChain {
            XCTAssertNil(self.viewModel.myToken, "Токен доступа должен быть nil, когда Keychain возвращает пустые данные")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    // Add more test methods to cover other scenarios and functionality of AddNewsViewModel
    
}

extension AddNewsViewModelTests {
    func saveNilTokenToKeychain() {
        let nilData: Data? = nil
        let nilString: String? = nil
        KeychainHelper.standard.save(nilData!, token: nilString!, account: "facebook")
    }
}
