//
//  CryptographyManager.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 8/11/22.
//

import Foundation
import CommonCrypto


class CommonCryptoManager: CryptographyProtocol {
    
    enum Operations {
        static let encrypt = kCCEncrypt
        static let decrypt = kCCDecrypt
    }
    
    private init() {}
    
    static func hmac256(text: String, key: String) -> Data? {
        
        guard let data = text.data(using: .utf8),
              let keyData = key.data(using: .utf8) else { return nil }
        
        let originaldataBytes = Array(data)
        let keyBytes = Array(keyData)
        
        var resultBytes = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH) )
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyBytes, keyBytes.count, originaldataBytes, originaldataBytes.count, &resultBytes)
        
        return Data(resultBytes)
    }
    
    static func sha256(text: String) -> Data? {
        
        guard let data = text.data(using: .utf8) else { return nil }
        let dataBytes = Array(data)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH) )
        
        CC_SHA256(dataBytes, UInt32(dataBytes.count), &digest)
        
        return Data(digest)
    }
    
    static func aes256_cbc(textData: Data, key: String, iv: Data, operation: Int) -> Data? {
        
        //The key must has 32 characters (32*8 = 256)
        guard let keyData = key.padding(toLength: 32, withPad: "x", startingAt: .zero).data(using: .utf8) else {
            return nil
        }
        
        let keyBytes = Array(keyData)
        let textBytes = Array(textData)
        
        var resultBytes = [UInt8](repeating: 0, count: textBytes.count + kCCBlockSizeAES128)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted = 0
        
        let status = CCCrypt(CCOperation(operation),
                             CCAlgorithm(kCCAlgorithmAES),
                             options,
                             keyBytes, keyBytes.count,
                             Array(iv),
                             textBytes, textBytes.count,
                             &resultBytes, resultBytes.count,
                             &numBytesEncrypted)
        
        if status == kCCSuccess {
            let outputBytes = resultBytes.prefix(numBytesEncrypted)
            return Data(outputBytes)
        } else {
            return nil
        }
    }
    
    static func aes_gcm(data: Data, key: Data, inicializationVector: Data, authenticator: Data, operation: Int, tag: Data?) -> (data: Data, tag: Data?)? {
        securePrint("CommonCrypto can't encode AES_GCM")
        return nil
    }
}
