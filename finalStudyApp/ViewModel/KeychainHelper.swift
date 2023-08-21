//
//  KeyChainForToken.swift
//  finalStudyApp
//
//  Created by dunice on 25.11.2022.
//

import SwiftUI
import Security

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    
    
    func save(_ data: Data, token: String, account: String) {
        
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: token,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
    }
    
    
    func read(token: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: token,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(token: String, account: String) {
        
        let query = [
            kSecAttrService: token,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
}

