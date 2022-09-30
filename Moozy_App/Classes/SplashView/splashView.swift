//
//  splashView.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

class SplashView: UIViewController {
    
    let imgLogo = UIImageView(image: #imageLiteral(resourceName: "logo"), contentModel: .scaleAspectFit)
    let lblName = UIImageView(image: #imageLiteral(resourceName: "Name"), contentModel: .scaleAspectFit)
    
    var viewModel: ChatListVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar(value: true)
        viewModel = ChatListVM()
        self.configureUI()
        self.gotoNextOptionScreen()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func configureUI() {
        view.backgroundColor = UIColor.white
        
        //add chatApp Logo
        self.view.addMultipleSubViews(views: imgLogo, lblName)
        
        //add constraints
        self.imgLogo.centerSuperView(xPadding: 0, yPadding: -20, size: .init(width: 200, height: 120))
        
        lblName.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 160, height: 100))
        lblName.horizontalCenterWith(withView: imgLogo)
    }
    
    private func gotoNextOptionScreen(){
        
        self.gotonextScreen()
        //Check Internet Availability
//        Reachability.isConnectedToNetwork { response in
//            if response{
//                self.gotonextScreen()
//            }else{
//                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                    self.showAlert(title: ConstantStrings.CustomSplash.title, message: ConstantStrings.CustomSplash.noInternetConnection, fromController: self, buttonText: "Ok", handler: nil)
//                })
//            }
//        }
    }
    
    private func gotonextScreen(){
        //After animation go to next screen that is BaseViewController
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
            if AppUtils.shared.user != nil{
//                APIServices.shared.getLoggedUser(UserEmail: AppUtils.shared.user?.data.email ?? "") { (response, errorMessage) in
//                      if response != nil{
//                       } else { }
//                  }
                self.pushTo(viewController: ChatListVC())
            }else{
                self.pushTo(viewController: LoginVC())
            }
        })
    }
}



public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
    }
}
