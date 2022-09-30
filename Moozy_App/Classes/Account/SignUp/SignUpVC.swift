//
//  SignUpVC.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 08/09/2022.
//

import Foundation
import UIKit

class signUpVC : UIViewController {
    
    var containerView: UIView?
    var scrollView: UIScrollView?
    
    var topHeaderView : UIView?
    var topNavigation : UIView?
    var imgLogo : UIImageView?
    var sepratorView : UIView?
    var lblLoginTittle : UILabel?
    var lblLogin : UILabel?
    var lblTitle : UILabel?
    var btnSignUp : MoozyActionButton?
    var btnBack : MoozyActionButton?
    
    var txtPasswrod : MoozyTextField?
    var txtRepeatPassword : MoozyTextField?
    var txtUserName : MoozyTextField?
    var txtEmail : MoozyTextField?
    
    var isMenu: Int = 0
    var viewModel: SignUpVM?
    var validator: Validator!
    
    init(isMenu: Int = 0){
        self.isMenu = isMenu
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar(value: true)
        view.backgroundColor = AppColors.secondaryColor
        viewModel = SignUpVM()
        configureUI()
        dataBinding()
        validation()
    }
    
    func initializedControls(){
        scrollView = UIScrollView()
        scrollView?.autoresizingMask = .flexibleHeight
        scrollView?.bounces = false
        scrollView?.showsVerticalScrollIndicator = false
        containerView = UIView()
        
       topNavigation  = {
            let view = UIView(backgroundColor: AppColors.primaryColor)
            
           btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: UIColor.white, backgroundColor: UIColor.clear,imageSize: backButtonSize) { [self] in
//                if isMenu == 1{
//                    UIApplication.shared.windows.first?.rootViewController = BaseSlidingController()
//                }else{
                    self.pop(animated: true)
//                }
            }
           lblTitle = UILabel(title: "", fontColor: UIColor.white, alignment: .center, font: UIFont.font(.Poppins, type: .Regular, size: 22))
           
            view.addMultipleSubViews(views: btnBack!, lblTitle!)
            
           btnBack?.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: 15, right: 0), size: .init(width: 20, height: 20))
            
           lblTitle?.anchor(top: nil, leading: btnBack?.trailingAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 17, bottom: 0, right: 0))
            lblTitle?.verticalCenterWith(withView: btnBack)
            return view
        }()
      
        sepratorView = UIView(backgroundColor: .white, maskToBounds: true)
        imgLogo = UIImageView(image:  #imageLiteral(resourceName: "logo"), contentModel: .scaleToFill)
       
        lblLoginTittle = UILabel(title: "Sing Up", fontColor: .black, alignment: .center, numberOfLines: 1, font: UIFont.font(.Poppins, type: .Regular, size: 38))
        
        btnSignUp  = MoozyActionButton(title: "Singn Up", font: UIFont.font(.Poppins, type: .Medium, size: 16), foregroundColor: .white, backgroundColor: AppColors.primaryColor, cornerRadius: 45/2){ [self] in
            viewModel?.signUp()
//            validator.validateNow { (isValid) in
//                if isValid == true{
//                    viewModel?.signUp()
//                }
//            }
        }
        
        lblLogin = UILabel( alignment : .center)
        
        var ForgettextArray = [String]()
        var underlineArray = [UIColor]()
        ForgettextArray =  ["already","singin"]
        underlineArray = [.white,.black]
        
        self.lblLogin?.attributedText = getAttributedString(arrayUnderlinecolor: underlineArray, arrayText: ForgettextArray)
        self.lblLogin?.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnForgetPass(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.lblLogin?.addGestureRecognizer(tapgesture)
        
       
        //TextFields
        txtPasswrod = MoozyTextField(icon: UIImage(systemName: "lock"), placeHolder: ConstantStrings.Login.Password, textInputType: .general, keyBoardType: .default, cornerRadius: 50/2)
        //(title: "", placeHolder: "text_email", textAlignment: .center)
        //
        
        txtRepeatPassword = MoozyTextField(icon: UIImage(systemName: "lock"), placeHolder: ConstantStrings.Login.RepeatPassword, textInputType: .general, keyBoardType: .default, cornerRadius: 50/2)
        
        //MoozyTextField(title: "", placeHolder: "text_email", textAlignment: .center)
        //
        
        //(title: "", placeHolder: "password", textAlignment: .center)
        txtEmail = MoozyTextField(icon: UIImage(systemName: "envelope"), placeHolder: ConstantStrings.Login.Email, textInputType: .email, keyBoardType: .default, cornerRadius: 50/2)
        //(title: "", placeHolder: "text_email", textAlignment: .center)
        //(icon: UIImage(systemName: "envelope"), placeHolder: ConstantStrings.Login.Email, textInputType: .email, keyBoardType: .default, cornerRadius: 50/2)
        
        
        txtUserName = MoozyTextField(icon: UIImage(systemName: "person"), placeHolder: ConstantStrings.Login.UserName, textInputType: .name, keyBoardType: .default, cornerRadius: 50/2)
        //(title: "", placeHolder: "text_email", textAlignment: .center)
        //(icon: UIImage(systemName: "envelope"), placeHolder: ConstantStrings.Login.UserName, textInputType: .email, keyBoardType: .default, cornerRadius: 50/2)
        
    }
    
   
    //ConfigureUI
    func configureUI(){
        initializedControls()
       
        view.addMultipleSubViews(views: topNavigation! , scrollView!)
       
        topNavigation?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: view.frame.width/5))
        
        scrollView?.anchor(top: topNavigation?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        scrollView?.addSubview(containerView!)
        containerView?.fillSuperView(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        containerView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        containerView?.addMultipleSubViews(views: imgLogo!,lblLoginTittle!,lblLogin!,btnSignUp!,txtUserName!,txtEmail!,txtPasswrod!,txtRepeatPassword!)
  
        containerView?.backgroundColor = .white
        scrollView?.backgroundColor = .white
    
       imgLogo?.anchor(top: containerView?.topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: sizeScreen.height -  0, left: 0, bottom: 0, right: 0 ),size: .init(width: 160, height: 160))
        imgLogo?.horizontalCenterWith(withView: containerView!)
        
        lblLoginTittle?.anchor(top: imgLogo?.bottomAnchor, leading: containerView?.leadingAnchor, bottom: nil, trailing: containerView?.trailingAnchor,padding: .init(top: 30, left: 40, bottom: 0, right: 40))
        
        lblLogin?.anchor(top: lblLoginTittle?.bottomAnchor, leading: lblLoginTittle?.leadingAnchor, bottom: nil, trailing: lblLoginTittle?.trailingAnchor,padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        
        txtUserName?.anchor(top: lblLogin?.bottomAnchor, leading: containerView?.leadingAnchor, bottom: nil, trailing: containerView?.trailingAnchor, padding:.init(top: 23, left: 20, bottom: 0, right: 20),size: .init(width: 0, height: 60))

        txtEmail?.anchor(top: txtUserName?.bottomAnchor, leading: txtUserName?.leadingAnchor, bottom: nil, trailing: txtUserName?.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 60))
        
        txtPasswrod?.anchor(top: txtEmail?.bottomAnchor, leading: txtUserName?.leadingAnchor, bottom: nil, trailing: txtUserName?.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 60))
     
        
        txtRepeatPassword?.anchor(top: txtPasswrod?.bottomAnchor, leading: txtPasswrod?.leadingAnchor, bottom: nil, trailing: txtPasswrod?.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
        
            //Below seprate line
        btnSignUp?.anchor(top: txtRepeatPassword?.bottomAnchor, leading: containerView?.leadingAnchor, bottom: containerView?.bottomAnchor, trailing: containerView?.trailingAnchor, padding:.init(top: 22, left: 40, bottom: 10, right: 40),size: .init(width: 0, height: 45))
        
    }
    
    func validation(){
        validator = Validator(withView: view)
        
        validator.add(textField: txtPasswrod!, rules: [.regex(.password)])
        validator.add(textField: txtRepeatPassword!, rules: [.matches(txtPasswrod!)])
        validator.add(textField: txtUserName!, rules: [.regex(.name)])
        validator.add(textField: txtEmail!, rules: [.regex(.email)])
    }
    
    
    func dataBinding(){
        
        viewModel?.isLoader.bind(observer: { [self] isLoad, _ in
            if isLoad.value!{
                ActivityController.shared.showActivityIndicator(uiView: view)
            }else{
                ActivityController.shared.hideActivityIndicator(uiView: view)
            }
        })
        
        txtPasswrod?.textField?.bind(with: viewModel!.email)
        
        txtRepeatPassword?.textField?.bind(with: viewModel!.password)
        
        txtUserName?.textField?.bind(with: viewModel!.first_name)
        
        txtEmail?.textField?.bind(with: viewModel!.last_name)
        
        viewModel?.message.bind(observer: { message, _ in
            print(message)
            self.showAlert(title: "Error!", message: "\(message.value ?? "")", fromController: self, buttonText: "ok", handler: nil)
        })
        
        viewModel?.isSignUp.bind(observer: { isSignUp, _ in
            if isSignUp.value!{
                self.ShowMessageAlert(inViewController: self, title: "Alert", message: "Register Sucessfuly.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.6) {
                    UIApplication.shared.currentUIWindow()?.rootViewController = UINavigationController(rootViewController: LoginVC())}
            }
        })
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension signUpVC  {
    
    //MARK: --TappedOnLabel
    @objc func tappedOnForgetPass(_ gesture: UITapGestureRecognizer) {
        
        guard let text = self.lblLogin?.text else { return }
        let conditionsRange = (text as NSString).range(of: "singin")
        
        if gesture.didTapAttributedTextInLabel(label: self.lblLogin!, inRange: conditionsRange) {
            self.pop(animated: true)
            
        }
    }
}



