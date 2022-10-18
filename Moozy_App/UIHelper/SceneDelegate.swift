//
//  SceneDelegate.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import UIKit
import GooglePlaces
import GoogleMaps
import IQKeyboardManager

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UIApplication.shared.statusBarStyle = .darkContent
        
        GMSPlacesClient.provideAPIKey("AIzaSyADEaQ6RjYxbgLSUAwo4ct56pJfeydBy7w")
        GMSServices.provideAPIKey("AIzaSyADEaQ6RjYxbgLSUAwo4ct56pJfeydBy7w")
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().enabledTouchResignedClasses
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
       
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: SplashView())
        window?.makeKeyAndVisible()
    }

    
    
}

