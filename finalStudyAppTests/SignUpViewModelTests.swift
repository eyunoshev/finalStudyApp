//
//  SignUpViewModelTests.swift
//  finalStudyAppTests
//
//  Created by dunice on 21.08.2023.
//

import XCTest
@testable import finalStudyApp

//TODO: - Делаю моки запросов и хардкожу данные

class MockUploadFile: UploadFile {
    var shouldSucceed: Bool = true
    
    override func uploadFile(image: UIImage, onComplete: @escaping (URLImage?) -> ()) {
        if shouldSucceed {
            let mockURLImage = URLImage(data: "MockURL", statusCode: 1, success: true)
            onComplete(mockURLImage)
        } else {
            onComplete(nil)
        }
    }
}

class MockRegister: Register {
    var shouldSucceed: Bool = true
    
    override func register(avatar: String, email: String, name: String, password: String, role: String, onComplete: @escaping (SignIn) -> ()) {
        if shouldSucceed {
            
            // здесь нам все равно что мы в вхдодные данные положим, если shouldSucceed = true мы вернем мок данные снизу
             
            let mockSignIn = SignIn(data: DataRegister(avatar: "MockAvatar", email: "test@example.com", id: "111111", name: "Antonio", role: "user", token: "MockToken"), statusCode: 1, success: 1)
            onComplete(mockSignIn)
        } else {
            // или вернем пустые данные
            
            onComplete(SignIn(data: nil, statusCode: 0, success: 0))
        }
    }
}

class SignUpViewModelTests: XCTestCase {

    var viewModel: SignUpViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SignUpViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testUploadFileWithMock() {
        let expectation = XCTestExpectation(description: "onComplete в методе")
        
        let mockUploadFile = MockUploadFile()
        mockUploadFile.shouldSucceed = true
        viewModel.uploadFileRequest = mockUploadFile
        
        viewModel.uploadFile(image: UIImage()) {
            XCTAssertEqual(self.viewModel.imageURL, "MockURL", "Некорректный URL-адрес изображения после загрузки")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUploadFileWithMockFailure() {
        let expectation = XCTestExpectation(description: "onComplete в методе")
        
        let mockUploadFile = MockUploadFile()
        mockUploadFile.shouldSucceed = false
        viewModel.uploadFileRequest = mockUploadFile
        
        viewModel.uploadFile(image: UIImage()) {
            XCTAssertNil(self.viewModel.imageURL, "URL-адрес изображения должен быть равен nil после неудачной загрузки")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRegisterWithMock() {
        let expectation = XCTestExpectation(description: "onComplete в методе")
        
        let mockRegister = MockRegister()
        mockRegister.shouldSucceed = true
        viewModel.signInRequest = mockRegister
        
        viewModel.register(avatar: "", email: "", name: "", password: "", role: "") {
            XCTAssertEqual(self.viewModel.myToken, "MockToken", "Неверный токен после регистрации")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRegisterFailureWithMock() {
        let expectation = XCTestExpectation(description: "onComplete в методе")
        
        let mockRegister = MockRegister()
        mockRegister.shouldSucceed = false
        viewModel.signInRequest = mockRegister
        
        viewModel.register(avatar: "", email: "", name: "", password: "", role: "") {
            XCTAssertNil(self.viewModel.myToken, "Токен должен быть равен nil после неудачной регистрации")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
