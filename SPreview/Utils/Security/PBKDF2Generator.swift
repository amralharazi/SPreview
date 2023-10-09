//
//  PBKDF2Generator.swift
//  SPreview
//
//  Created by Amr on 9.10.2023.
//

import CommonCrypto
import Foundation

final class PBKDF2Generator {
    
    static func generateKey(password: String) throws -> Data {
        let keyByteCount = 32
        let rounds = 10000
        var derivedKey = Data(repeating: 0, count: keyByteCount)

        try derivedKey.withUnsafeMutableBytes { derivedKeyBytes in
            guard let derivedKeyRawPointer = derivedKeyBytes.baseAddress else {
                throw NSError(domain: "Error", code: 0, userInfo: nil)
            }

            let passwordData = password.data(using: .utf8)!
            try passwordData.withUnsafeBytes { passwordBytes in
                guard let passwordRawPointer = passwordBytes.baseAddress else {
                    throw NSError(domain: "Error", code: 0, userInfo: nil)
                }

                let result = CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    passwordRawPointer,
                    passwordData.count,
                    nil,
                    0,
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                    UInt32(rounds),
                    derivedKeyRawPointer,
                    keyByteCount
                )

                if result != kCCSuccess {
                    throw NSError(domain: "Error", code: Int(result), userInfo: nil)
                }
            }
        }

        return derivedKey
    }

}
