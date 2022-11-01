//
//  UIViewController+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit
import SafariServices


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

    // MARK: - Alerts
    func showAlert(title:String?, message:String? ,fromController:UIViewController, buttonText:String, handler:alertActionHandler?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: buttonText, style: .default, handler: handler)
        alertController.addAction(OkAction)
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


// MARK: Basic UIViewController Functions
extension UIViewController{
    
    public func pushTo(viewController: UIViewController, animated: Bool = true){
            navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func pop(animated: Bool = true){
        navigationController?.popViewController(animated: animated)
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
