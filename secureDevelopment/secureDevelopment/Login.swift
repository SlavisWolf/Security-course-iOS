//
//  Login.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 5/11/22.
//

import Foundation
import AuthenticationServices
 
class LoginSession: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    
    var webAuthSession: ASWebAuthenticationSession?
    
    func loginWithGoogle() {
        let googleOauthUrl = URL(string: Google.oauthUrl)!
        webAuthSession = ASWebAuthenticationSession(url: googleOauthUrl,
                                                    callbackURLScheme: "") { (callback:URL?, error:Error?) in
            
            securePrint("Prueba")
        }
        
        // Run the session
        webAuthSession?.presentationContextProvider = self
        webAuthSession?.prefersEphemeralWebBrowserSession = true
        webAuthSession?.start()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
