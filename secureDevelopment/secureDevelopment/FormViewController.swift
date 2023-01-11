//
//  FormViewController.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 7/11/22.
//

import UIKit
import LocalAuthentication

class FormViewController: UIViewController {
    
    @IBOutlet weak var biometryBtn: UIButton!
    
    
    let iv = CryptoKitManager.randomKeyGenerator(bits: 1024)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configBiometry()
        enablePasteboardObserver()
        
        generateNumbers()
        
        securePrint("CommonCrypto")
        
        commonSha256()
        commonAes256_cbc()
        
        securePrint("\n\nCryptoKit")
        kitSha256()
        cryptoKitAesGcm()
        
    }
    
    @IBAction func biometryClicked() {
        let context = LAContext()
        let biotext = context.biometryType == .faceID ? "Face ID" : "Touch ID"
        
        usingBiometric = true
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use your \(biotext) for authenticate") { (success, error) in
            
            if success {
                print("Ok, you're the one you said")
            } else {
                print("You're lying")
            }
            usingBiometric = false
        }
    }
    
    
    private func configBiometry() {
        
        let context = LAContext()
        var error: NSError?
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            switch context.biometryType {
                
            case .touchID:
                biometryBtn.setTitle(" Touch ID", for: .normal)
                biometryBtn.setImage(UIImage(systemName: "touchid"), for: .normal)
            case .faceID:
                biometryBtn.setTitle(" Face ID", for: .normal)
                biometryBtn.setImage(UIImage(systemName: "faceid"), for: .normal)
            default:
                biometryBtn.isHidden = true
            }
            
        } else {
            biometryBtn.isHidden = true
        }
        
    }
    
    private func enablePasteboardObserver(_ enable: Bool = true) {
        if enable {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(clipboard(sender:)),
                                                   name: UIPasteboard.changedNotification,
                                                   object: nil)
        } else {
            NotificationCenter.default.removeObserver(self,
                                                      name: UIPasteboard.changedNotification,
                                                      object: nil)
        }
    }
    
    @objc func clipboard(sender: NSNotification) {
        let pasteboard = UIPasteboard.general
        if pasteboard.hasStrings {
            securePrint(pasteboard.string!)
            enablePasteboardObserver(false)
            pasteboard.string = nil
            enablePasteboardObserver()
        }
    }
    
    private func generateNumbers() {
        
        securePrint("Random generator")
        if let random = randomKeyGenerator(bits: 2048) {
            securePrint(random)
            securePrint(Array(random) )
        }
        
        securePrint("Random generator CryptoKit")
        let randomCryptoKit = CryptoKitManager.randomKeyGenerator(bits: 2048)
        securePrint(randomCryptoKit)
        securePrint(Array(randomCryptoKit) )
    }
    
    private func commonSha256() {
        securePrint("sha256")
        if let sha256 = CommonCryptoManager.sha256(text: "I'll be encrypted and secret!") {
            securePrint(sha256.base64EncodedString() )
        }
    }
    
    private func kitSha256() {
        securePrint("sha256")
        if let sha256 = CryptoKitManager.sha256(text: "I'll be encrypted and secret!") {
            securePrint(sha256.base64EncodedString() )
        }
    }
    
    private func commonAes256_cbc() {
        
        securePrint("AES256_CBC")
        
        let key = "my treasure!"
        let textToEncode = "51 area experiments"
        
        guard let encoded = CommonCryptoManager.aes256_cbc(textData: textToEncode.data(using: .utf8)!,
                                                                 key: key,
                                                                 iv: iv,
                                                                 operation: CommonCryptoManager.Operations.encrypt) else { return }
        
        let base64 = encoded.base64EncodedString()
        securePrint("Encoded text = \(base64)")
        
        // Now We're going to decode
        
        let dataToDecoded = Data(base64Encoded: base64)!
        
        
        guard let decoded = CommonCryptoManager.aes256_cbc(textData: dataToDecoded,
                                                                 key: key,
                                                                 iv: iv,
                                                                 operation: CommonCryptoManager.Operations.decrypt) else { return }
        
        let textDecoded = String(data: decoded, encoding: .utf8)!
        
        securePrint("Decoded text = \(textDecoded)")
        
        
    }
    
    private func cryptoKitAesGcm() {
        securePrint("AES_GCM")
        // Multiple of sixteen
        let key = "hsyapdjgbe4o1apu".data(using: .utf8)!
        let authenticator = "o2hs899acz>1kopr".data(using: .utf8)!
        let originalText = "I travel through the space with R2-D2"
        let textData = originalText.data(using: .utf8)!
        securePrint("Original text: \(originalText)")
        
        guard let resultEncrypted = CryptoKitManager.aes_gcm(data: textData,
                                                           key: key,
                                                           inicializationVector: iv,
                                                           authenticator: authenticator,
                                                           operation: CryptoKitManager.Operations.encrypt.rawValue,
                                                           tag: nil),
              let tag = resultEncrypted.tag else { return }
        
        let base64 = resultEncrypted.data.base64EncodedString()
        securePrint("Encoded text: \(base64)")
        securePrint("Tag: \(tag.base64EncodedString() )")
        
        let dataToDecrypt = Data(base64Encoded: base64)!
        guard let resultDecrypted = CryptoKitManager.aes_gcm(data: dataToDecrypt,
                                                             key: key,
                                                             inicializationVector: iv,
                                                             authenticator: authenticator,
                                                             operation: CryptoKitManager.Operations.decrypt.rawValue,
                                                             tag: tag) else { return }
        
        
        securePrint("Decoded text: \(String(data: resultDecrypted.data, encoding: .utf8)!)")
        
    }


}
