//
//  TestContentViewModel.swift
//  finalStudyAppTests
//
//  Created by dunice on 21.08.2023.
//

import XCTest
import Combine
@testable import finalStudyApp

class ContentViewModelTests: XCTestCase {

    var viewModel: ContentViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = ContentViewModel()
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testLogIn() {
        let expectation = XCTestExpectation(description: "Log in completion called")

        viewModel.logIn(email: "test@example.com", password: "password") {
            XCTAssertEqual(self.viewModel.imageURL, "https://news-feed.dunice-testing.com/api/v1/file/12445898-44df-429e-93d4-ffde392b5a37.png", "Incorrect image URL after login")
            XCTAssertEqual(self.viewModel.myProfile?.name, "Antonio", "Incorrect profile name after login")
            XCTAssertEqual(self.viewModel.myToken, "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3MjVjZWM3NS1lNzAwLTRmMjItOTU4NC1hZWY1YjI1NDk4YTciLCJleHAiOjE2OTM4NzIwMDB9.wLPtDI15ikebhL5W0kexYRxiQH2A21beI2CcFY268V1LTIr65-byb6_6VLEyOKo_6KPQfv7Pjdbsr7R98Ax_9A", "Incorrect token after login")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLogInWithIncorrectCredentials() {
            let expectation = XCTestExpectation(description: "Log in completion called")

            viewModel.logIn(email: "test@example.com", password: "wrongPassword") {
                XCTAssertNil(self.viewModel.imageURL, "Image URL should not be updated with incorrect login")
                XCTAssertNil(self.viewModel.myProfile, "My profile should not be updated with incorrect login")
                XCTAssertNil(self.viewModel.myToken, "My token should not be updated with incorrect login")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }

    func testSaveToken() {
        let myToken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2NTRiNzllNS04NjFhLTQwYzMtYTY0YS0wMmJiYjRhYTFjNWQiLCJleHAiOjE2OTAwNzA0MDB9.FRX-hG8OEPSeWI6LCKaZYFfhMtnKKPOKq5CHdFqDhZ-_C5Pd8J97WdMQ_06GoyswfBaxU5rZQ-1gxRxljBVkzQ"
        viewModel.saveToken(myToken: myToken)
    }

    func testTakeTokenFromKeyChain() {
        let expectation = XCTestExpectation(description: "Take token completion called")

        let myToken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2NTRiNzllNS04NjFhLTQwYzMtYTY0YS0wMmJiYjRhYTFjNWQiLCJleHAiOjE2OTAwNzA0MDB9.FRX-hG8OEPSeWI6LCKaZYFfhMtnKKPOKq5CHdFqDhZ-_C5Pd8J97WdMQ_06GoyswfBaxU5rZQ-1gxRxljBVkzQ"
        viewModel.saveToken(myToken: myToken)
        
        viewModel.takeTokenFromKeyChain {
            XCTAssertEqual(self.viewModel.myToken, myToken, "Token not retrieved correctly from Keychain")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testTokenNotUpdatedWithoutLogIn() {
            let expectation = XCTestExpectation(description: "Token not updated completion called")

            viewModel.takeTokenFromKeyChain {
                XCTAssertNil(self.viewModel.myToken, "Token should not be updated without proper log in")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }

    func testGetUserInfo() {
        let expectation = XCTestExpectation(description: "Get user info completion called")

        // Simulate the token being set
        viewModel.myToken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3MjVjZWM3NS1lNzAwLTRmMjItOTU4NC1hZWY1YjI1NDk4YTciLCJleHAiOjE2OTM4NzIwMDB9.wLPtDI15ikebhL5W0kexYRxiQH2A21beI2CcFY268V1LTIr65-byb6_6VLEyOKo_6KPQfv7Pjdbsr7R98Ax_9A"
        
        viewModel.getUserInfo {
            XCTAssertEqual(self.viewModel.myProfile?.name, "Antonio", "Incorrect profile name after getting user info")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetUserInfoWithMissingToken() {
            let expectation = XCTestExpectation(description: "Get user info completion called")

            viewModel.getUserInfo {
                XCTAssertNil(self.viewModel.myProfile, "My profile should not be updated without proper token")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }
    
    func testAsyncMethodsCompletion() {
            let logInExpectation = XCTestExpectation(description: "Log in completion called")
            let userInfoExpectation = XCTestExpectation(description: "Get user info completion called")

            viewModel.logIn(email: "test@example.com", password: "password") {
                logInExpectation.fulfill()
            }

            viewModel.getUserInfo {
                userInfoExpectation.fulfill()
            }

            wait(for: [logInExpectation, userInfoExpectation], timeout: 10.0)
        }

    
    
}
