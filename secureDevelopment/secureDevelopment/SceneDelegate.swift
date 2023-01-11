//
//  SceneDelegate.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 9/10/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow? {
        didSet {
            AppDelegate.window = window
        }
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
        
        window?.rootViewController = newViewcontroller
        window?.makeKeyAndVisible()
        
        
//        connect(URL(string: "https://applecoding.com/category/noticias")!, completion: { data in
//            securePrint(data)
//        })
        //Download
//        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
//            let fileDownloader = FileDownloader()
//            fileDownloader.download(url: url, name: "Fichero.bin")
//        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        if !usingBiometric {
            backFromMultitask()
        }
    }

    // This is called when we launch touch id or face id
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        if !usingBiometric {
            UIPasteboard.general.items.removeAll()
            obfuscateMultitask()
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        backFromMultitask()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        UIPasteboard.general.items.removeAll()
        obfuscateMultitask()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let url = URLContexts.first?.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let items = components.queryItems else {
            return
        }
        
        window?.rootViewController?.dismiss(animated: true)
        if let code = items.first, code.name == "code", let value = code.value {
            Google.tokenCode = value
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OKGOOGLE"), object: nil)
        }
    }
    
    
    private func obfuscateMultitask() {
        
        let multitaskController = UIStoryboard(name: "Multitask", bundle: nil).instantiateInitialViewController()!
        multitaskController.modalPresentationStyle = .fullScreen
        window?.rootViewController?.present(multitaskController, animated: false)
    }
    
    private func backFromMultitask() {
        window?.rootViewController?.dismiss(animated: false)
    }


}

