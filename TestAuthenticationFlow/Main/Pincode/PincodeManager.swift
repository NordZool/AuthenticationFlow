//
//  PincodeManager.swift
//  TestAuthenticationFlow
//
//  Created by admin on 4.06.24.
//

import Foundation

class PincodeManager {
    private let service = "PINCODE"
    
    func savePincodeInKeyChain(_ pincode: String) throws -> Bool {
        let query: [CFString: Any] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService: service,
            kSecValueData : pincode.data(using: .utf8) ?? Data()
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeyChainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeyChainError.unknow(status: status)
        }
        
        return true
    }
    
    private func getPinCode() throws -> String? {
        let query: [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecMatchLimit as String: kSecMatchLimitOne,
                                       kSecReturnAttributes as String: true,
                                       kSecReturnData as String: true,
                                          kSecAttrService as String : service
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw KeyChainError.unknow(status: status) }
        
        guard let existingItem = result as? [String : Any],
            let pinData = existingItem[kSecValueData as String] as? Data,
            let pin = String(data: pinData, encoding: String.Encoding.utf8)
        else {
            return nil
        }
        
        return pin
    }
    
    func deletePinCode() -> Bool {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service
            ]
            
            let status = SecItemDelete(query as CFDictionary)
            return status == errSecSuccess
        }
    
    func matchPincode(with inputPin: String) throws -> Bool {
        let pincode = try getPinCode()
        
        return inputPin == pincode
    }
    
    func isPincodeExists() -> Bool {
        do {
            return (try getPinCode()) != nil
        } catch {
            print(error)
            return false
        }
    }
}

enum KeyChainError : Error {
    case duplicateItem
    case noPassword
    case unexpectedPasswordData
    case unknow(status: OSStatus)
}
