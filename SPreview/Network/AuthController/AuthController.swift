//
//  AuthController.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation
import Security

struct AuthController {
    
    // MARK: Properties
    static let shared = AuthController()
    
    // MARK: Init
    private init(){}
    
    // MARK: Helpers
    func setValue(_ value: String, for key: String) throws {
        guard let encodedValue = value.data(using: .utf8) else {
            throw AuthControllerError.string2DataConversionError
        }
        
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
          var attributesToUpdate: [String: Any] = [:]
          attributesToUpdate[String(kSecValueData)] = encodedValue
          
          status = SecItemUpdate(query as CFDictionary,
                                 attributesToUpdate as CFDictionary)
          
          if status != errSecSuccess {
            throw error(from: status)
          }
          
        case errSecItemNotFound:
          query[String(kSecValueData)] = encodedValue
          
          status = SecItemAdd(query as CFDictionary, nil)
          if status != errSecSuccess {
            throw error(from: status)
          }
          
        default:
          throw error(from: status)
        }
    }
    
    func getValue(for key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        
        var queryResult: CFTypeRef?
        
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        switch status {
        case errSecSuccess:
            guard let queriedItem = queryResult as? [String: Any],
                  let valueData = queriedItem[String(kSecValueData)] as? Data,
                  let value = String(data: valueData,
                                        encoding: .utf8) else {
                throw AuthControllerError.data2StringConversionError
            }
            return value
            
        case errSecItemNotFound:
            return nil
            
        default:
            throw error(from: status)
        }
    }
    
    private func error(from status: OSStatus) -> AuthControllerError {
        let message = SecCopyErrorMessageString(status, nil) as String?
        let nonOptionalMessage = message ?? NSLocalizedString("Unhandled Error", comment: "")
        return AuthControllerError.unhandledError(message: nonOptionalMessage)
    }
}
