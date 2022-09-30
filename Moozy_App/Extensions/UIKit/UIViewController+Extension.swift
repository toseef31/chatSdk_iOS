//
//  UIViewController+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit
import SafariServices


extension UIViewController{
    func add(asChildViewController viewController: UIViewController, contentView: UIView, removeFirst: Bool = true){
        
        
        //First Remove all Child from View Controller
        if removeFirst{
            children.forEach({
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            })
        }
        
        addChild(viewController) // Add Child View Controller
        
        contentView.addSubview(viewController.view) // Add Child View as Subview
        
        viewController.view.fillSuperView()//Fill to SuperView
        
        viewController.view.frame = contentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParent: self) // Notify Child View Controller
    }
}

extension UIViewController
{
    typealias alertActionHandler = (UIAlertAction) -> Void
    
    
    func swipePop(delegate: UIGestureRecognizerDelegate){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = delegate
    }
    
    func hideKeyboardWhenTappedAround() {
        view.addTapGesture(tagId: 0) { _ in
            self.view.endEditing(true)
        }
    }
    open func openSafariController(urlStr: String){
        if let url = URL(string: urlStr){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
        
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.preferredBarTintColor = UIColor.black
            vc.modalPresentationStyle = .formSheet
            vc.preferredControlTintColor = .white
            present(vc, animated: true)
        }
    }

    // MARK: - Alerts
    func showAlert(title:String?, message:String? ,fromController:UIViewController, buttonText:String, handler:alertActionHandler?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: buttonText, style: .default, handler: handler)
        alertController.addAction(OkAction)
        fromController.present(alertController, animated: true, completion: nil)
    }

    func confirmationAlert(title:String?, message:String? ,fromController:UIViewController, okButtonText:String, cancelButtonText:String, yesHandler:alertActionHandler?,noHandler:alertActionHandler?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: okButtonText, style: .default, handler: yesHandler)
        let noAction = UIAlertAction(title: cancelButtonText, style: .cancel, handler: noHandler)
        noAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        fromController.present(alertController, animated: true, completion: nil)
    }

    func hideTabBar(_ indexTab: Int = -1)
    {
        var tabs = self.tabBarController?.viewControllers
        if indexTab != -1{
            tabs?.remove(at: indexTab)
        }
        tabBarController?.setViewControllers(tabs, animated: true)
    }
}



extension UIWindow {

    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }

    static func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if let navigationController = vc as? UINavigationController,
            let visibleController = navigationController.visibleViewController  {
            return UIWindow.getVisibleViewControllerFrom( vc: visibleController )
        } else if let tabBarController = vc as? UITabBarController,
            let selectedTabController = tabBarController.selectedViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: selectedTabController )
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}


// MARK: Basic UIViewController Functions
extension UIViewController{
    // Initialize Next ViewController Where You Move
    public func nextViewController<T: UIViewController>(storyBoardName: String = "Main", moveToViewController: T) -> T  {
        let storyBoard: UIStoryboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyBoard.setViewController(type: T.self)
        viewController?.modalPresentationStyle = .overFullScreen
        return viewController!
    }
    
    // Initialize TabBarController With Identifier UITabBarController
    public func nextTabBarController(storyBoardName: String = "Main") -> UITabBarController
    {
        let tabBarController = nextViewController(storyBoardName: storyBoardName, moveToViewController: UITabBarController())
        return tabBarController
    }
    
    public func pushTo(viewController: UIViewController, animated: Bool = true){
            navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func presentTo(viewController: UIViewController, animated: Bool = true){
        self.present(viewController, animated: animated, completion: nil)
    }
    
    public func dismissPresentViewController(animation: Bool = true) {
        dismiss(animated: animation, completion: nil)
    }

    public func pop(animated: Bool = true){
        navigationController?.popViewController(animated: animated)
    }

    public func popTo(ofClass: AnyClass, animated: Bool = true){
        navigationController?.popToViewController(ofClass: ofClass, animated: animated)
    }
    
    public func customAltert<T: UIViewController>(storyBoardName: String = "Main", moveToViewController: T) -> T
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyBoard.setViewController(type: T.self)
        viewController?.providesPresentationContextTransitionStyle = true
        viewController?.definesPresentationContext = true
        viewController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //        viewController?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        return viewController!
    }
}

//  MARK: Custom UIAlert Functions
extension UIViewController{
    
    //Confirmation Alert With Two Button
    func confirmationAlert(title:String?, message:String? ,fromController:UIViewController, yesButtonText:String, noButtonText:String, yesHandler:alertActionHandler?,noHandler:alertActionHandler?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: yesButtonText, style: .default, handler: yesHandler)
        let noAction = UIAlertAction(title: noButtonText, style: .cancel, handler: noHandler)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        fromController.present(alertController, animated: true, completion: nil)
    }
}

//  MARK: Common Methods
extension UIViewController {
    
    // Open URL
    public func openURL(_ url: URL) {
        let controller = SFSafariViewController(url: url)
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    //  Phone Call
    func phoneCall(phoneNumber: String) {
        if let phoneURL = URL(string: ("tel://" + phoneNumber.replacingOccurrences(of: "[ |()-]", with: "", options: [.regularExpression])))
        {
            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(phoneURL)
                } else {
                    UIApplication.shared.openURL(phoneURL)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Send Email
    func sendEmail(email: String){
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

//  MARK:  UITabBarController
extension UIViewController {

    func enableTabbarItems(_ items: [Int]) {
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as NSArray? {
            for i in 0..<arrayOfTabBarItems.count {
                if items.contains(i) {
                    if let tabBarItem = arrayOfTabBarItems[i] as? UITabBarItem {
                        tabBarItem.isEnabled = true
                    }
                }
            }
        }
    }
    
    func disableAllTabbarItems() {
        if let arrayOfTabBarItems = tabBarController?.tabBar.items as NSArray? {
            for i in 0..<arrayOfTabBarItems.count {
                if let tabBarItem = arrayOfTabBarItems[i] as? UITabBarItem {
                    tabBarItem.isEnabled = false
                }
            }
        }
    }
}

//  MARK: Set Status Bar
extension UIViewController {
    final class func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = style == .lightContent ? UIColor.clear : .white
            statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
        }
    }
}

//  MARK: Hide NavigationBar
extension UIViewController {
    public func hideNavigationBar(value: Bool){
        navigationController?.setNavigationBarHidden(value, animated: false)
    }
    
    public func dismissKeyboard() {
        self.view.endEditing(true)
    }
}


//  MARK: Read From JSON File
extension UIViewController{
    public func readJSONFile(fileName: String) -> [String : Any]?{
           //Now lets populate our TableView
           let newUrl = Bundle.main.url(forResource: fileName, withExtension: "json")
           
           guard let j = newUrl
               else{
                   print("data not found")
                   return nil
           }
           
           guard let d = try? Data(contentsOf: j)
               else { print("failed")
                   return nil
           }
           
           guard let rootJSON = try? JSONSerialization.jsonObject(with: d, options: [])
               else{ print("failed")
                   return nil
           }
           
           return rootJSON as? [String: Any]
       }
}


//MARK: UINavigationController
extension UINavigationController {
    
    public func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    public func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
}

//This function is use to show the Controller inito present viewControler
extension UIViewController{
    func ShowPopUp(PopView: UIViewController ){
        let vc = PopView
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
 }

extension UIViewController{
    func ShowMessageAlert(inViewController: UIViewController,title:String,message:String,completion:(() -> ())? = nil )
    {
        let Alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        inViewController.present(Alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            Alert.dismiss(animated: true, completion: nil)
            if completion != nil
            {
                completion!()
            }
        }
    }
}


//  MARK: UIStoryBoard Basic
extension UIStoryboard {
    
    // Storyboard Intializzed
    public func setViewController<T:UIViewController>(type: T.Type) -> T? {
        let viewControllerIdentifier = String(describing: T.self)
        return self.instantiateViewController(withIdentifier: viewControllerIdentifier) as? T
    }
}
