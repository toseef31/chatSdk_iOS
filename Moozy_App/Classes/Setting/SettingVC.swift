//
//  SettingVC.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 04/08/2022.
//

import Foundation
import UIKit
import SDWebImage

class settingVC: UIViewController{
    
    var topHeaderView: UIView?
     var optionView: UIView?
     //TopHeaderView
    var btnBack: MoozyActionButton?
    var seperatorView: UIView?
   //OptionView
    var tblOptionList: UITableView?
    let listArray = ConstantStrings.chatSetting.options
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         configureUI()
       
    }
    
    
    func initializedControls(){
        view.backgroundColor = UIColor.white
        
        topHeaderView = {
            let view = UIView(backgroundColor: .white)
            
            let title = UILabel(title: "Setting", fontColor: AppColors.BlackColor, alignment: .center, font: UIFont.font(.PottaOne, type: .Medium, size: 14))
            
            let btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: AppColors.BlackColor, backgroundColor: UIColor.clear,imageSize: backButtonSize) {
                self.pop(animated: true)
            }
            
            view.addMultipleSubViews(views: title, btnBack)
            
            btnBack.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 14, right: 0), size: backButtonSize)
            
            title.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            title.verticalCenterWith(withView: btnBack)
            
            return view
        }()
        
     
        optionView = {
            let hView = UIView(backgroundColor: UIColor.white)
            configureTableView()
            return hView
        }()
    }
    
    
    func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: topHeaderView!, optionView!)
        
        topHeaderView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        topHeaderView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
      
              
        optionView?.anchor(top: topHeaderView?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        //TopHeaderView Constraints
        btnBack?.anchor(top: topHeaderView?.safeAreaLayoutGuide.topAnchor, leading: topHeaderView?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 8, bottom: 0, right: 0), size: backButtonSize)
        
        //OptionView Constraints
        optionView?.addSubview(tblOptionList!)
        tblOptionList?.fillSuperView(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    
    //Configure Tableview
    func configureTableView(){
        tblOptionList = UITableView()
        tblOptionList?.register(SettingCell.self, forCellReuseIdentifier:  ConstantStrings.cell)
        tblOptionList?.delegate = self
        tblOptionList?.dataSource = self
        tblOptionList?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tblOptionList?.showsVerticalScrollIndicator = false
        tblOptionList?.isScrollEnabled = false
    }
}

extension settingVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstantStrings.cell) as! SettingCell
        cell.selectionStyle = .none
        cell.setData = listArray[indexPath.row]
        cell.selectionStyle = .none
        if indexPath.row == 3 {
            if AppUtils.shared.getOnlineStatus == 1 {
                cell.settingSwitch.isOn = true
            } else {
                cell.settingSwitch.isOn = false
                
            }
        }
        if indexPath.row == 4 {
            if AppUtils.shared.getTypingStatus == 1 {
                cell.settingSwitch.isOn = true
            } else {cell.settingSwitch.isOn = false}
        }
        cell.onSwitchValueChange = { [self] _ticketID in
          print(_ticketID)
            print(indexPath.row)
            print(listArray[indexPath.row].title ?? "")
            
            switch (indexPath.row) {
            case 3:
              
                if _ticketID == "ON" {
                    APIServices.shared.userOnlineStatus(status: "1")
                    AppUtils.shared.saveUserOnline(typingStatus: 1)
                }
                else {
                    APIServices.shared.userOnlineStatus(status: "0")
                    AppUtils.shared.saveUserOnline(typingStatus: 0)
                    
                }
            case 4:
                if _ticketID == "ON" {
                    AppUtils.shared.saveUserTyping(typingStatus: 1)
                }
                else {
                    AppUtils.shared.saveUserTyping(typingStatus: 0)
                    
                }
            default:
                break
                
                }
           
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        
        
        if indexPath.row != 3 && indexPath.row != 4 && indexPath.row != 5{
            self.pushTo(viewController: friendOperationVC(OperationType: listArray[indexPath.row].title ?? "")  )
        }
        if  indexPath.row == 3 {
            self.pushTo(viewController: bookMarkVC())
        }
        
    }
}
