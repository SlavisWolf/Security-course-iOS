//
//  DocumentsViewController.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 7/11/22.
//

import UIKit

class DocumentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    @IBAction func saveFileWithText() {
        
        let urlDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let urlFile = urlDocuments.appending(path: "basicFile.txt")
        var urlFileNoItunesBackup = urlDocuments.appending(path: "hateItunesBackup.txt")
        
        let textToSave = "Belen is a beauty"
        
        try? textToSave.write(to: urlFile, atomically: true, encoding: .utf8)
        try? textToSave.write(to: urlFileNoItunesBackup, atomically: true, encoding: .utf8)
        
        let savedText = (try? String(contentsOf: urlFile, encoding: .utf8)) ?? ""
        
        securePrint(savedText)
        
        var config = URLResourceValues()
        config.isExcludedFromBackup = true
        
        do {
            try urlFileNoItunesBackup.setResourceValues(config)
        } catch {
            securePrint("Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func saveFileWithData() {
        
        let urlDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let urlFile = urlDocuments.appending(path: "fileWithData.txt")
        
        let textToSave = "I'll be data"
        let textAsData = textToSave.data(using: .utf8)
        
        try? textAsData?.write(to: urlFile, options: [.atomic, .completeFileProtection]) // The file is encrypted while the phone is locked
        guard let savedData = try? Data(contentsOf: urlFile, options: .uncached) else { return }
        let savedText = String(data: savedData, encoding: .utf8) ?? ""
        
        securePrint(savedText)
    }
    
    @IBAction func keychain() {
        
        let textToSave = "Rings of power is boring"
        guard let dataToSave = textToSave.data(using: .utf8) else { return }
        
        let result = saveKeychain(key: "One_Ring", data: dataToSave)
        
        guard result == noErr else { return }
        
        guard let dataSaved = loadKeyChain(key: "One_Ring"),
                let textSaved = String(data: dataSaved, encoding: .utf8) else { return }
        
        securePrint(textSaved)
        
        
        //Check hashs are equal
        
        securePrint("HASH VERIFICATION")
        securePrint("CommonCrypto")
        //Key must be the same
        let dataToSaveHash = CommonCryptoManager.hmac256(text: textToSave, key: "Key_One")
        let dataSavedHash = CommonCryptoManager.hmac256(text: textSaved, key: "Key_One")
        
        if dataToSaveHash == dataSavedHash {
            securePrint("Hashs match")
            securePrint(dataToSaveHash?.base64EncodedString() ?? "" )
        } else {
            securePrint("Hashs don't match")
        }
        
        securePrint("CryptoKit")
        //Key must be the same
        let dataToSaveHash2 = CryptoKitManager.hmac256(text: textToSave, key: "Key_One")
        let dataSavedHash2 = CryptoKitManager.hmac256(text: textSaved, key: "Key_One")
        
        if dataToSaveHash2 == dataSavedHash2 {
            securePrint("Hashs match")
            securePrint(dataToSaveHash?.base64EncodedString() ?? "" )
        } else {
            securePrint("Hashs don't match")
        }
    }
    
    func saveKeychain(key: String, data: Data) -> OSStatus {
        
        let query: [String: Any] = [kSecClass as String : kSecClassGenericPassword as String,
                                    kSecAttrAccount as String : key,
                                    kSecValueData as String: data]
        
        // To avoid add more than one record for the same key, we remove before add
        SecItemDelete(query as CFDictionary) // If the record doesn't exist nothing will happen
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    func loadKeyChain(key: String) -> Data? {
        let query: [String: Any] = [kSecClass as String : kSecClassGenericPassword as String,
                                    kSecAttrAccount as String : key,
                                    kSecReturnData as String: kCFBooleanTrue as Any,
                                    kSecMatchLimit as String: kSecMatchLimitOne as String]
        
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        return status == noErr ? dataTypeRef as? Data : nil
    }
}

