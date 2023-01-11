//
//  CryptoKitManager.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 9/11/22.
//

import Foundation
import CryptoKit


class CryptoKitManager: CryptographyProtocol {
    
    enum Operations: Int {
        
        case encrypt = 1
        case decrypt = 0
    }
    
    
    private init() {}
    
    static func randomKeyGenerator(bits: Int) -> Data {
        let result = SymmetricKey(size: SymmetricKeySize(bitCount: bits) )
        let data = result.withUnsafeBytes { bytes in
            return Data(Array(bytes))
        }
        return data
    }
    
    static func hmac256(text: String, key: String) -> Data? {
        guard let data = text.data(using: .utf8), let keyData = key.data(using: .utf8) else { return nil }
        let symmetricKey = SymmetricKey(data: keyData)
        let digest = HMAC<SHA256>.authenticationCode(for: data, using: symmetricKey)
        return Data(digest)
    }
    
    static func sha256(text: String) -> Data? {
        guard let data = text.data(using: .utf8) else { return nil }
        let digest = SHA256.hash(data: data)
        return Data(digest)
    }
    
    static func aes256_cbc(textData: Data, key: String, iv: Data, operation: Int) -> Data? {
        // I don't find the way to do this with CryptoKit
        return nil
    }
    
    // YOU CAN USE ChaChaPoly INSTEAD OF AES_GCM WITH THE SAME METHODS
    // Apple recomend this function of encryption
    static func aes_gcm(data: Data, key: Data, inicializationVector: Data, authenticator: Data, operation: Int, tag: Data?) -> (data: Data, tag: Data?)? {
        
        let operation = Operations(rawValue: operation) ?? .encrypt
        
        let symmetricKey = SymmetricKey(data: key)
        var result: (data: Data, tag:Data?)?
        do {
            let nonce = try AES.GCM.Nonce(data: inicializationVector)
            if operation == .encrypt {
                let sealedBoxData = try AES.GCM.seal(data,
                                                      using:symmetricKey,
                                                      nonce: nonce,
                                                      authenticating: authenticator)
                
                result = (sealedBoxData.ciphertext, sealedBoxData.tag)
            } else {
                guard let tag else { return nil }
                let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: data, tag: tag)
                let resultData = try AES.GCM.open(sealedBox, using: symmetricKey, authenticating: authenticator)
                result = (resultData, nil)
            }
            
            return result
            
        } catch {
            return nil
        }
    }
    
    
    
    
    
    
    
}
