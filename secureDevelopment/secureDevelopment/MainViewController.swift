//
//  ViewController.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 9/10/22.
//

import UIKit
import SafariServices
import AuthenticationServices


class MainViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(obtainToken), name: NSNotification.Name("OKGOOGLE"), object: nil)
    }

    
    
    @IBAction func googleLogin(_ sender: Any) {
        //testWebAuthSession()
        loginWithSafari()
    }
    
    
    private func loginWithSafari() {
        let url = URL(string: Google.oauthUrl)!
        let safariVc = SFSafariViewController(url: url)
        present(safariVc, animated: true)
    }
    private func testWebAuthSession() {
        let login = LoginSession()
        login.loginWithGoogle()
    }
    
    @objc func obtainToken() {
        
        guard let url = URL(string: Google.getTokenUrlWithCode) else { return }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf8", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data, error == nil, let response = response as? HTTPURLResponse else {
                securePrint("Error: \(error!)")
                return
            }
            
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase // Important because I've written the variables in camelCase and json return snake_case
                    let tokenData = try decoder.decode(OAuth2TokenInfo.self, from: data)
                    if let refreshToken = tokenData.refreshToken {
                        Google.refreshToken = refreshToken
                        self.uploadFile(file: Bundle.main.url(forResource: "beach", withExtension: "jpeg")! )
                    }
                }
                catch {
                    securePrint("Serialization error: \(error)")
                }
            } else {
                securePrint("Error of code \(response.statusCode)")
            }
        }.resume()
    }
    
    func uploadFile(file: URL) {
        let urlRefresh = Google.getTokenUrlWithRefresh
        guard !urlRefresh.isEmpty, let url = URL(string: urlRefresh) else { return }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf8", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data, error == nil, let response = response as? HTTPURLResponse else {
                securePrint("Error: \(error!)")
                return
            }
            
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase // Important because I've written the variables in camelCase and json return snake_case
                    let tokenData = try decoder.decode(OAuth2TokenInfo.self, from: data)
                    self.uploadGoogle(file: file, token: tokenData.accessToken)
                }
                catch {
                    securePrint("Serialization error: \(error)")
                }
            } else {
                securePrint("Error of code \(response.statusCode)")
            }
        }.resume()
    }
    
    func uploadGoogle(file: URL, token: String) {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: Google.uploadFileDriveUrl)! )
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        session.uploadTask(with: request, fromFile: file) { (data, response, error) in
            
            guard let data, error == nil, let response = response as? HTTPURLResponse else {
                securePrint("Error: \(error!)")
                return
            }
            
            if response.statusCode == 200 {
                securePrint(String(data: data, encoding: .utf8)! )
            }
            
        }.resume()
    }
}

