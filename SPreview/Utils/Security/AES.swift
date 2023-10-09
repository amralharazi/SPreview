//
//  AES.swift
//  SPreview
//
//  Created by Amr on 9.10.2023.
//

import CommonCrypto
import Foundation

struct AES {
    
    // MARK: Properties
    private let key: Data
    private let iv: Data
    
    // MARK: Init
    init?(key: Data, iv: Data) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256 else {
            debugPrint("Error: Invalid key size.")
            return nil
        }
        
        guard iv.count >= kCCBlockSizeAES128 else {
            debugPrint("Error: Invalid IV size.")
            return nil
        }
        
        self.key = key
        self.iv = iv
    }
    
    // MARK: Helpers
    func encrypt(data: Data) -> Data? {
        return crypt(data: data, option: CCOperation(kCCEncrypt))
    }
    
    func decrypt(data: Data) -> Data? {
        return crypt(data: data, option: CCOperation(kCCDecrypt))
    }
    
    func crypt(data: Data, option: CCOperation) -> Data? {
        let cryptLength = size_t(data.count + iv.count)
        var cryptData = Data(count: cryptLength)
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(
                            option,
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress,
                            key.count,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress,
                            data.count,
                            cryptBytes.baseAddress,
                            cryptLength,
                            &bytesLength
                        )
                    }
                }
            }
        }
        
        guard status == kCCSuccess else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}
