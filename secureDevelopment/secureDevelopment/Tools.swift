//
//  Tools.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 10/10/22.
//

import Foundation
import UIKit


var usingBiometric = false

struct OAuth2TokenInfo: Codable {
    
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let refreshToken: String?
}

func connect(_ url: URL, completion: @escaping (_ data: Data) -> Void) {
    
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/x-www-form-urlencoded; charset=utf8", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    request.setValue("no-cache", forHTTPHeaderField: "cache-control")
    

    session.dataTask(with: request) { (data, response, error) in
        
        guard let data, error == nil, let response = response as? HTTPURLResponse else {
            securePrint("Error: \(error!)")
            return
        }
        
        if response.statusCode == 200 {
            completion(data)
        } else {
            securePrint("Error of code \(response.statusCode)")
        }
    }.resume()
}

func upload(url: URL, photo: UIImage) {
    
    guard let resizedImage = photo.resize(newWith: 150),
          let imageData = resizedImage.jpegData(compressionQuality: 0.8) else { return }
    
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("no-cache", forHTTPHeaderField: "cache-control")
    
    let fileUpload = FileUpload(name: "testImage", image: imageData.base64EncodedString(options: .lineLength64Characters) )
    let encoder = JSONEncoder()
    
    
    guard let json = try? encoder.encode(fileUpload) else {
        securePrint("Error creating the JSON Body")
        return
    }
    
    request.httpBody = json
    session.dataTask(with: request) { (data, response, error) in
        
        guard let data, error == nil, let response = response as? HTTPURLResponse else {
            securePrint("Error: \(error!)")
            return
        }
        
        if response.statusCode == 200 {
            
            let decoder = JSONDecoder()
            let responseJSON = try? decoder.decode(ResponseUpload.self, from: data)
            
            securePrint(responseJSON?.message ?? "")
        }
    }
}


func securePrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        print(items, separator: separator, terminator: terminator)
    #endif
}
