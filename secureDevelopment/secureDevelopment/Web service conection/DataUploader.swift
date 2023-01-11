//
//  DataUploader.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 12/10/22.
//

import UIKit

class DataUploader: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    func uplodad(url: URL, file: URL) {
        
        guard let serverURL = URL(string: "\(url.absoluteString)/\(file.lastPathComponent)") else {
            return
        }
        
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        
        session.uploadTask(with: request, fromFile: file) { (data, response, error) in
            guard let data, error == nil, let response = response as? HTTPURLResponse else {
                securePrint("Error: \(error!)")
                return
            }
            
            if response.statusCode == 200 {
                
                securePrint(String(data: data, encoding: .utf8) ?? "Can not transform data into string" )
                
            }
        }.resume()
    }
    
    //MARK: URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let error {
            securePrint("Error uploading: \(error)")
        } else {
            securePrint("Upload complete properly")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        
        securePrint("Uploaded \(progress * 100)%")
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        completionHandler(.allow)
    }

}
