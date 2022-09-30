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
        onlineStatusUpdate(onlineStatus: 1)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: SplashView())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
        onlineStatusUpdate(onlineStatus: 0)
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        onlineStatusUpdate(onlineStatus: 1)
        print("sceneDidBecomeActive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        onlineStatusUpdate(onlineStatus: 1)
        print("sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        onlineStatusUpdate(onlineStatus: 1)
        print("sceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        onlineStatusUpdate(onlineStatus: 0)
        print("sceneDidEnterBackground")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        onlineStatusUpdate(onlineStatus: 0)
    }
    
    func onlineStatusUpdate(onlineStatus: Int){
        APIServices.shared.setOnlineStatus(onlineStatus: onlineStatus) { (response, errorMesage) in
            if response != nil{
                print("online Status")
            }else{
                print("Error")
            }
        }
    }
}

