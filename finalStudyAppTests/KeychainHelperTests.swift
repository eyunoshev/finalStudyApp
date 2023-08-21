//
//  KeychainHelperTests.swift
//  finalStudyAppTests
//
//  Created by dunice on 21.08.2023.
//

import XCTest
import Security
@testable import finalStudyApp


// Mock wrapper for SecItem  в самом низу привел документацию если интересно, нашел на просторах интернета
class SecItemWrapper {
    static var statusToReturn: OSStatus = errSecSuccess
    static var dataToReturn: Data?
    
    static func add(_ query: NSDictionary, _ result: UnsafeMutablePointer<AnyObject?>?) -> OSStatus {
        if statusToReturn == errSecSuccess {
            dataToReturn = query[kSecValueData] as? Data
        }
        return statusToReturn
    }
    
    
    static func copyMatching(_ query: CFDictionary, _ result: UnsafeMutablePointer<AnyObject?>?) -> OSStatus {
        if let data = dataToReturn {
            result?.pointee = data as AnyObject
            return errSecSuccess
        }
        return errSecItemNotFound
    }
    
    static func delete(_ query: CFDictionary) -> OSStatus {
        dataToReturn = nil
        return errSecSuccess
    }
}




class KeychainHelperTests: XCTestCase {
    
    var keychainHelper: KeychainHelper!
    
    override func setUp() {
        super.setUp()
        keychainHelper = KeychainHelper.standard
    }
    
    override func tearDown() {
        keychainHelper = nil
        super.tearDown()
    }
    
    func testSaveAndReadDataFromKeychain() {
        let token = "token"
        let account = "facebook"
        let testData = "Test data".data(using: .utf8)!
        
        // Используем SecItem
        SecItemWrapper.statusToReturn = errSecSuccess
        SecItemWrapper.dataToReturn = testData // Устанавливаем данные для возврата
        
        //Сначала сохраняем данные в keyChain потом достаем через read
        keychainHelper.save(testData, token: token, account: account)
        let readData = keychainHelper.read(token: token, account: account)
        
        // ну и собственно проверка на равенство
        XCTAssertEqual(readData, testData, "Данные, считываемые из связки ключей, должны совпадать с сохраненными данными")
    }
    
    func testDeleteDataFromKeychain() {
        let token = "token"
        let account = "facebook"
        let testData = "Test data".data(using: .utf8)!
        
        SecItemWrapper.statusToReturn = errSecSuccess
        SecItemWrapper.dataToReturn = testData
        
        // для начала установим данные и потом их через delete удалим
        keychainHelper.save(testData, token: token, account: account)
        keychainHelper.delete(token: token, account: account)
        let readData = keychainHelper.read(token: token, account: account)
        
        // проверяем что в readData ничего нет
        XCTAssertNil(readData, "Данные должны быть нулевыми после удаления из связки ключей")
    }
}

//SecItemWrapper представляет собой вспомогательный класс, который обертывает методы работы с ключами в SecItem, частью фреймворка Security. Эти методы используются для управления данными в системном хранилище ключей, таким как хранилище паролей, секретных ключей и других конфиденциальных данных. Работа с SecItem проводится через методы save, read и delete.
//Однако SecItem является частью операционной системы и нельзя напрямую мокировать его статические методы для тестирования. Поэтому мы создаем этот класс SecItemWrapper, который обертывает вызовы статических методов SecItem и позволяет нам управлять результатами, которые они возвращают, в тестах.
//Вот как работает SecItemWrapper:
//Вам нужно установить ожидаемый результат для методов SecItemWrapper, чтобы имитировать успешные или неудачные операции, а также установить данные, которые будут "возвращаться" этих методами (например, данные, которые должны быть сохранены или прочитаны из хранилища).
//В тесте, перед вызовом методов save, read и delete, вы можете установить ожидаемые значения статуса операции и "возвращаемых" данных, вызвав методы SecItemWrapper.
//Теперь вместо реального взаимодействия с системным хранилищем ключей через SecItem, ваш класс KeychainHelper будет использовать SecItemWrapper. Это позволяет вам контролировать результаты этих методов в тестах, создавая различные сценарии для проверки.
//Короче говоря, SecItemWrapper создает контролируемую среду для тестирования ваших методов работы с ключами, позволяя вам имитировать различные сценарии и проверять правильность работы вашего кода в разных условиях.
