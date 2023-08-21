//
//  TestContentViewModel.swift
//  finalStudyAppTests
//
//  Created by dunice on 21.08.2023.
//

import XCTest
import Combine
@testable import finalStudyApp


//TODO: - Делаю моки запросов и хардкожу данные


class MockLogIn: LogIn {
    
    // можно протестить что будет если запрос не пройдет
    var shouldSucceed: Bool = true
    var mockResponseData: [String: Any]? = [
        "data": [
            "avatar": "https://news-feed.dunice-testing.com/api/v1/file/12445898-44df-429e-93d4-ffde392b5a37.png",
            "email": "test@example.com",
            "id": "725cec75-e700-4f22-9584-aef5b25498a7",
            "name": "Antonio",
            "role": "user",
            "token": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3MjVjZWM3NS1lNzAwLTRmMjItOTU4NC1hZWY1YjI1NDk4YTciLCJleHAiOjE2OTM4NzIwMDB9.wLPtDI15ikebhL5W0kexYRxiQH2A21beI2CcFY268V1LTIr65-byb6_6VLEyOKo_6KPQfv7Pjdbsr7R98Ax_9A"
        ],
        "statusCode": 1,
        "success": 1
    ]
    
    var mockError: Error?
    
    // Мок для запроса logIn
    
    override func logIn(email: String, password: String, onComplete: @escaping (SignIn) -> ()) {
        if shouldSucceed {
            if let mockResponseData = mockResponseData {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: mockResponseData, options: [])
                    let decodedLogIn = try JSONDecoder().decode(SignIn.self, from: jsonData)
                    onComplete(decodedLogIn)
                } catch {
                    // Обработка ошибки декодирования
                }
            } else {
                // Обработка отсутствия mockResponseData
            }
        } else {
            let error = mockError ?? NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
            // Вызов onComplete с nil в дате
            onComplete(SignIn(data: nil, statusCode: 0, success: 0))
        }
    }
}



class MockUserRequests: UserRequests {
    var shouldSucceed: Bool = true
    
    
    // Мок для запроса getUserInfo
    
    override func getUserInfo(myToken: String, onComplete: @escaping (SignIn) -> ()) {
        
        let mockData: [String: Any] = [
            "data": [
                "avatar": "https://news-feed.dunice-testing.com/api/v1/file/12445898-44df-429e-93d4-ffde392b5a37.png",
                "email": "test@example.com",
                "id": "725cec75-e700-4f22-9584-aef5b25498a7",
                "name": "Antonio",
                "role": "user",
                "token": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3MjVjZWM3NS1lNzAwLTRmMjItOTU4NC1hZWY1YjI1NDk4YTciLCJleHAiOjE2OTM4NzIwMDB9.wLPtDI15ikebhL5W0kexYRxiQH2A21beI2CcFY268V1LTIr65-byb6_6VLEyOKo_6KPQfv7Pjdbsr7R98Ax_9A"
            ],
            "statusCode": 1,
            "success": 1
        ]
        
        if shouldSucceed {
            let jsonData = try! JSONSerialization.data(withJSONObject: mockData, options: [])
            let decoder = JSONDecoder()
            guard let decodedProfileUser = try? decoder.decode(SignIn.self, from: jsonData) else { return }
            DispatchQueue.main.async {
                onComplete(decodedProfileUser)
            }
        } else {
            // Имитация ошибки
            DispatchQueue.main.async {
                // Создание ошибки
                let error = NSError(domain: "MockErrorDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])
                // onComplete с пустыми данными, как раз тестом проверю на nil
                onComplete(SignIn(data: nil, statusCode: 0, success: 0))
            }
        }
    }
}



class ContentViewModelTests: XCTestCase {
    
    var viewModel: ContentViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    // это обязательные 2 метода первый для настройки тест обьекта, tearDown для очищения
    
    override func setUp() {
        super.setUp()
        viewModel = ContentViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // мок запроса logIn
    
    func testLogInWithMock() {
        let expectation = XCTestExpectation(description: "Log in completion called")
        
        let mockLogIn = MockLogIn()
        mockLogIn.shouldSucceed = true
        viewModel.logInRequest = mockLogIn
        
        let mockUserRequests = MockUserRequests()
        mockUserRequests.shouldSucceed = true
        viewModel.usersRequests = mockUserRequests
        
        viewModel.logIn(email: "test@example.com", password: "password") {
            XCTAssertEqual(self.viewModel.imageURL, "https://news-feed.dunice-testing.com/api/v1/file/12445898-44df-429e-93d4-ffde392b5a37.png", "Incorrect image URL after login")
            XCTAssertEqual(self.viewModel.myProfile?.name, "Antonio", "Incorrect profile name after login")
            XCTAssertEqual(self.viewModel.myToken, "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3MjVjZWM3NS1lNzAwLTRmMjItOTU4NC1hZWY1YjI1NDk4YTciLCJleHAiOjE2OTM4NzIwMDB9.wLPtDI15ikebhL5W0kexYRxiQH2A21beI2CcFY268V1LTIr65-byb6_6VLEyOKo_6KPQfv7Pjdbsr7R98Ax_9A", "Incorrect token after login")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // тут тест ловит пустые данные с запроса лог ин при вводе неправильных кредов 

    func testLogInWithIncorrectCredentials() {
        let expectation = XCTestExpectation(description: "Log in completion called")
        
        let mockLogIn = MockLogIn()
        mockLogIn.shouldSucceed = false
        viewModel.logInRequest = mockLogIn
        
        let mockUserRequests = MockUserRequests()
        mockUserRequests.shouldSucceed = false
        viewModel.usersRequests = mockUserRequests
        
        viewModel.logIn(email: "test@example.com", password: "wrongPassword") {
            XCTAssertNil(self.viewModel.imageURL, "Image URL should not be updated with incorrect login")
            XCTAssertNil(self.viewModel.myProfile, "My profile should not be updated with incorrect login")
            XCTAssertNil(self.viewModel.myToken, "My token should not be updated with incorrect login")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    //Проверка работы кейчейна
    
    func testSaveAndTakeTokenFromKeyChain() {
        let expectation = XCTestExpectation(description: "Take token completion called")
        
        //сначала сохраняем токен в кей чейн
        
        let myToken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2NTRiNzllNS04NjFhLTQwYzMtYTY0YS0wMmJiYjRhYTFjNWQiLCJleHAiOjE2OTAwNzA0MDB9.FRX-hG8OEPSeWI6LCKaZYFfhMtnKKPOKq5CHdFqDhZ-_C5Pd8J97WdMQ_06GoyswfBaxU5rZQ-1gxRxljBVkzQ"
        viewModel.saveToken(myToken: myToken)
        
        // теперь пробуем достать
        
        viewModel.takeTokenFromKeyChain {
            XCTAssertEqual(self.viewModel.myToken, myToken, "Token not retrieved correctly from Keychain")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
 
    // запрос getUserInfo с мок данными
    
    func testGetUserInfoWithMock() {
        let expectation = XCTestExpectation(description: "Get user info completion called")
        
        let mockUserRequests = MockUserRequests()
        mockUserRequests.shouldSucceed = true
        viewModel.usersRequests = mockUserRequests // Подменяем зависимость моком
        
        viewModel.myToken = "TestToken" // Устанавливаем токен
        
        viewModel.getUserInfo {
            XCTAssertEqual(self.viewModel.myProfile?.name, "Antonio", "Incorrect profile name after getting user info")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // тут смотрим если с запроса на получения данных ничего не пришло
    
    func testGetUserInfoWithMockError() {
        let expectation = XCTestExpectation(description: "Get user info completion called")
        
        let mockUserRequests = MockUserRequests()
        mockUserRequests.shouldSucceed = false // Устанавливаем моку генерацию ошибки
        viewModel.usersRequests = mockUserRequests // Подменяем зависимость моком
        
        viewModel.myToken = "TestToken" // Устанавливаем токен
        
        viewModel.getUserInfo {
            XCTAssertNil(self.viewModel.myProfile, "My profile should not be updated on error")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    // тут проверяю правильную последовательность выполнения комплишенов
    
    func testAsyncMethodsCompletion() {
        let logInExpectation = XCTestExpectation(description: "Log in completion called")
        let userInfoExpectation = XCTestExpectation(description: "Get user info completion called")
        
        let mockUserRequests = MockUserRequests()
        let mockLogIn = MockLogIn()
        viewModel.usersRequests = mockUserRequests // Подменяем зависимость моком
        viewModel.logInRequest = mockLogIn
        
        
        viewModel.logIn(email: "test@example.com", password: "password") {
            logInExpectation.fulfill()
        }
        
        viewModel.getUserInfo {
            userInfoExpectation.fulfill()
        }
        
        wait(for: [logInExpectation, userInfoExpectation], timeout: 10.0)
    }
}

