//
//  CryptographyProtocol.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 9/11/22.
//
import Foundation

protocol CryptographyProtocol {
    
    static func hmac256(text: String, key: String) -> Data?
    static func sha256(text: String) -> Data?
    static func aes256_cbc(textData: Data, key: String, iv: Data, operation: Int) -> Data?
    static func aes_gcm(data: Data, key: Data, inicializationVector: Data, authenticator: Data, operation: Int, tag: Data?) -> (data: Data, tag: Data?)?
}


//Create iv for cryptography (Initialization Vector)
func randomKeyGenerator(bits: Int) -> Data? {
    
    var randomBytes = [UInt8](repeating: 0, count: bits/8)
    let result = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    return result == errSecSuccess ? Data(randomBytes) : nil
}
