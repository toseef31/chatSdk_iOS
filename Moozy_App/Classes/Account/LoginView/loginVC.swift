//
//  loginVC.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit
import AVFoundation

class LoginVC: UIViewController, UITextFieldDelegate{
    
    var headerView: UIView?
    var lblWelcome: UILabel?
    var lblSubTitle: UILabel?
    
    var txtPhoneNumber: MoozyTextField?
    var txtPassword: MoozyTextField?
    var btnLogin: MoozyActionButton?
    var btnSignUp: MoozyActionButton?
    var btnForgotPassword: MoozyActionButton?
    
    var viewModel: LoginVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginVM()
        configureUI()
        dataBinding()
        self.hideNavigationBar(value: true)
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
        print("Permission granted")
        case AVAudioSession.RecordPermission.denied:
        print("Pemission denied")
        case AVAudioSession.RecordPermission.undetermined:
        print("Request permission here")
        AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
            // Handle granted
        })
        }
    }
    
    //Initialized Controls
    func initializedControls(){
        view.backgroundColor = UIColor.white
        headerView = UIView(backgroundColor: AppColors.primaryColor)
        
        lblWelcome = UILabel(title: ConstantStrings.Login.LoginType, fontColor: UIColor.black, alignment: .left, font: UIFont.font(.Poppins, type: .Bold, size: 14))
        
        lblSubTitle = UILabel(title: ConstantStrings.Login.wellcome, fontColor: UIColor.black, alignment: .left, numberOfLines: 0, font: UIFont.font(.Poppins, type: .Regular, size: 12))
        
        txtPhoneNumber = MoozyTextField(icon: UIImage(systemName: "envelope"), placeHolder: ConstantStrings.Login.Email, textInputType: .email, keyBoardType: .default, cornerRadius: 50/2)
        
        txtPassword = MoozyTextField(icon: UIImage(systemName: "lock"), placeHolder: ConstantStrings.Login.Password, textInputType: .email, keyBoardType: .default, isSecured: true, cornerRadius: 45/2)
        
        btnLogin = MoozyActionButton(title: ConstantStrings.Login.Login, font: UIFont.font(.Poppins, type: .SemiBold, size: 12), foregroundColor: AppColors.primaryFontColor, backgroundColor: AppColors.primaryColor, cornerRadius: 45/2){ [self] in
            if txtPhoneNumber?.text != ""{
                viewModel?.loginUser(phone: txtPhoneNumber!.text, password: txtPassword!.text)
                
            }else{
               self.ShowMessageAlert(inViewController: self, title: "Alert", message: "Required")
            }
        }
        
    
        btnSignUp = MoozyActionButton(title: ConstantStrings.Login.SignUp, font: UIFont.font(.Poppins, type: .SemiBold, size: 12), foregroundColor: UIColor.black){ [self] in
            print("SignUp....")
          //  self.pushTo(viewController: signUpVC())
        }
       
        
        btnForgotPassword = MoozyActionButton(title: ConstantStrings.Login.ForgotPassword, font: UIFont.font(.Poppins, type: .SemiBold, size: 12), foregroundColor: UIColor.black){
            print("Forgot Password")
        }
    }
    
    //ConfigureUI
    func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: headerView!, lblWelcome!, lblSubTitle!, txtPhoneNumber!, txtPassword!, btnLogin!,btnSignUp! , btnForgotPassword!)
        btnForgotPassword?.isHidden = true
        btnSignUp?.isHidden = true
        
        headerView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 80, left: 16, bottom: 0, right: 0), size: .init(width: 60, height: 5))
        
        lblWelcome?.anchor(top: headerView?.bottomAnchor , leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        lblSubTitle?.anchor(top: lblWelcome?.bottomAnchor, leading: lblWelcome?.leadingAnchor, bottom: nil, trailing: lblWelcome?.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        txtPhoneNumber?.anchor(top: lblSubTitle?.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24, left: 24, bottom: 0, right: 24), size: .init(width: 0, height: 55))
        
        txtPassword?.anchor(top: txtPhoneNumber?.bottomAnchor, leading: txtPhoneNumber?.leadingAnchor, bottom: nil, trailing: txtPhoneNumber?.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 55))
        
        btnLogin?.anchor(top: txtPassword?.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: totalWidth/2, height: 45))
        
        btnForgotPassword?.anchor(top: btnLogin?.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 8, left: 0, bottom: 0, right: 0),size: .init(width: totalWidth/2, height: 30))
        
        btnSignUp?.anchor(top: btnForgotPassword?.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 1, left: 0, bottom: 0, right: 0), size: .init(width: totalWidth/2 , height: 30))
        
        btnLogin?.horizontalCenterWith(withView: view)
        btnForgotPassword?.horizontalCenterWith(withView: view)
        btnSignUp?.horizontalCenterWith(withView: view)
    }
    
    //Data Binding ViewModel
    func dataBinding(){
        //Loader
        viewModel?.isLoader.bind(observer: { [self] isLoad, _ in
            if isLoad.value!{
                ActivityController.shared.showActivityIndicator(uiView: view)
            }else{
                ActivityController.shared.hideActivityIndicator(uiView: view)
            }
        })
        
        //Login Sucess / Failed
        viewModel?.isCreate.bind(observer: { [self] isCreate, _ in
            if isCreate.value == ""{
                self.pushTo(viewController: ChatListVC())
            }else{
                self.showAlert(title: "Error!", message: "\(isCreate.value!)", fromController: self, buttonText: "Ok", handler: nil)
            }
        })
    }
}

