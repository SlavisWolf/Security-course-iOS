//
//  Constants.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 12/10/22.
//

import Foundation


let bundleId = Bundle.main.bundleIdentifier ?? ""


enum Google {
    
    static var tokenCode: String?
    static var refreshToken: String?
    
    static let scope = "https://www.googleapis.com/auth/drive"
    static let clientID = "1093222665271-9gd5l24m6oks86t2ibkv3kujo6jogkc2.apps.googleusercontent.com"
    
    private static let redirectUri = "\(bundleId):/oauth2redirect"
    
    static var oauthUrl: String  {
        return "https://accounts.google.com/o/oauth2/v2/auth?client_id=\(clientID)&redirect_uri=\(redirectUri.urlEncoded)&response_type=code&scope=\(scope.urlEncoded)"
    }
    
    private static let getTokenUrl = "https://oauth2.googleapis.com/token"
    
    static var getTokenUrlWithCode: String {
        guard let tokenCode else { return "" }
        return "\(getTokenUrl)?code=\(tokenCode)&client_id=\(clientID)&redirect_uri=\(redirectUri.urlEncoded)&grant_type=authorization_code"
    }
    
    static var getTokenUrlWithRefresh: String {
        guard let refreshToken else { return "" }
        return "\(getTokenUrl)?refresh_token=\(refreshToken)&client_id=\(clientID)&grant_type=refresh_token"
    }
    
    static let uploadFileDriveUrl = "https://www.googleapis.com/upload/drive/v3/files"
    
}
