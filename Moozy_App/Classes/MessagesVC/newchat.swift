//
//  newchat.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 06/10/2022.
//

import Foundation
import UIKit
import SwiftUI
import CryptoSwift

class ChaatViewController: UIViewController {
    
    var topHeaderView: UIView?
    var viewProfile : UIView?
    var Profilelblname : UILabel?
    var viewstatus : UIView?
    var lblonline : UIView?
    var chatContentview : UIView?
    var viewUserName : UIView?
    var lblFriendName : UILabel?
    var bottomview : UIView?
    var bottomContentview : UIView?
    var lblInputtext : UILabel?
    var frindProfile : UIImageView?
    
    var scrollView = UIScrollView()
    var scrollConte = UIView()
    //Tableview..
    var tblOptionList: UITableView?
    var heightTableview: NSLayoutConstraint!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        config ()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        // Do any additional setup after loading the view.
    }
    
    //Configure Tableview
    func configureTableView(){
        tblOptionList = UITableView()
        tblOptionList?.register(SettingCell.self, forCellReuseIdentifier: "cell")
        tblOptionList?.delegate = self
        tblOptionList?.dataSource = self
        tblOptionList?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tblOptionList?.showsVerticalScrollIndicator = false
        tblOptionList?.isScrollEnabled = false
        tblOptionList?.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    //Reload Device Detail Table view
    func reloadTableView(){
        self.tblOptionList?.layoutIfNeeded()
        self.tblOptionList?.layoutIfNeeded()
        
        
        if (self.tblOptionList?.contentSize.height) ?? 0 < ((view.frame.width/4.8) + 95) {
            
            self.heightTableview.constant =  (view.frame.width) - 50
        } else {
            
            heightTableview = tblOptionList?.heightAnchor.constraint(equalToConstant: 30)
            
            self.heightTableview.constant =  (self.tblOptionList?.contentSize.height)!
            heightTableview.priority = UILayoutPriority.init(999)
            heightTableview.isActive = true
            
            self.heightTableview.constant =  (self.tblOptionList?.contentSize.height) ?? 0
            
        }
        self.tblOptionList?.reloadData()
        self.tblOptionList?.layoutIfNeeded()
    }
    //Height of Device Detail Table view
    func tableHeight(){
        reloadTableView()
    }
    func initilzation () {
        
        topHeaderView = {
            let view = UIView(backgroundColor: AppColors.primaryColor)
            
            let title = UILabel(title: "Setting", fontColor: AppColors.secondaryColor, alignment: .center, font: UIFont.font(.Poppins, type: .Regular, size: 14))
            
            let btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: AppColors.secondaryColor, backgroundColor: UIColor.clear,imageSize: backButtonSize) {
                print("Back")
//                self.dismiss(animated: true, completion: nil)
                self.pop(animated: true)
            }
            
            view.addMultipleSubViews(views: title, btnBack)
            
            btnBack.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 14, right: 0), size: backButtonSize)
            
            title.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            title.verticalCenterWith(withView: btnBack)
            
            return view
        }()
        
     
        
        viewProfile = UIView(backgroundColor: #colorLiteral(red: 0.04705882353, green: 0.831372549, blue: 0.7843137255, alpha: 1), cornerRadius: 47.5, borderColor: #colorLiteral(red: 0.04705882353, green: 0.831372549, blue: 0.7843137255, alpha: 1), maskToBounds: true)
        
        Profilelblname = UILabel(title: "T", fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), alignment: .center, numberOfLines: 1, font: UIFont.font(.Roboto, type: .Medium, size: 50))
        
        viewstatus = UIView(backgroundColor: #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1), cornerRadius: 7.5, borderColor: #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1), borderWidth: 1, maskToBounds: true)
        
        lblonline = UILabel(title: "Online", fontColor: #colorLiteral(red: 0.1098039216, green: 0.1058823529, blue: 0.1215686275, alpha: 1), alignment: .right, numberOfLines: 1, font: UIFont.font(.Roboto, type: .Light, size: 10))
        
        chatContentview = UIView(backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cornerRadius: 0, borderColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderWidth: 1, maskToBounds: true)
        chatContentview?.roundCorners(corners: [.topLeft, .topRight], radius: 32, clipToBonds: true)
        
        chatContentview?.backgroundColor = .yellow
        
        viewUserName = UIView(backgroundColor: #colorLiteral(red: 1, green: 0.3529411765, blue: 0.3764705882, alpha: 1), cornerRadius: 24, borderColor: #colorLiteral(red: 1, green: 0.3529411765, blue: 0.3764705882, alpha: 1), borderWidth: 1, maskToBounds: true)
       
        lblFriendName = UILabel(title: "The Fun Begins", fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), alignment: .center, numberOfLines: 1, font: UIFont.font(.Roboto, type: .Medium, size: 17))
       
        bottomview = UIView(backgroundColor: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1), cornerRadius: 32, borderColor: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1), borderWidth: 1, maskToBounds: true)
       
        bottomContentview = UIView(backgroundColor: .yellow, cornerRadius: 0, maskToBounds: true)
        bottomContentview?.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 32, clipToBonds: true)
        
        lblInputtext = UILabel(title: "From Joy joy friends", fontColor: #colorLiteral(red: 0.5098039216, green: 0.5294117647, blue: 0.5882352941, alpha: 1), alignment: .left, numberOfLines: 1, font: UIFont.font(.Roboto, type: .Medium, size: 12))
        
        frindProfile = UIImageView(image: UIImage(named: "profile3")!, contentModel: .scaleAspectFit)
        frindProfile?.layer.cornerRadius = 12.5
        
    }
    
    func config () {
        initilzation ()
    
        view.addMultipleSubViews(views: topHeaderView!,scrollView,bottomContentview!)
        
        topHeaderView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.width/4.8))
        scrollView.anchor(top: topHeaderView?.bottomAnchor, leading: view.leadingAnchor, bottom: bottomContentview?.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        
       // scrollView.fillSuperView(padding: .init(top: 110, left: 0, bottom: 0, right: 0))
        scrollView.addSubview(scrollConte)
        scrollConte.fillSuperView(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        scrollConte.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollConte.addMultipleSubViews(views:  viewProfile!,viewstatus!,lblonline!,chatContentview!,viewUserName!,lblFriendName!)
        
        
        
        viewProfile?.addSubview(Profilelblname!)
        chatContentview?.addMultipleSubViews(views: tblOptionList!)
        bottomContentview?.addSubview(bottomview!)
        bottomview?.fillSuperView(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        bottomview?.addMultipleSubViews(views:lblInputtext!,frindProfile!)
        
        viewProfile?.anchor(top: self.scrollConte.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0),size: .init(width: 95 , height: 95))
        viewProfile?.horizontalCenterWith(withView: scrollConte)
       
        Profilelblname?.centerSuperView()
        Profilelblname?.horizontalCenterWith(withView: viewProfile)
        
        viewstatus?.anchor(top: viewProfile?.bottomAnchor, leading: viewProfile?.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: -15, left: 0, bottom: 0, right: 0), size: .init(width: 15, height: 15))
        lblonline?.anchor(top: nil, leading: viewstatus?.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        
         lblonline?.verticalCenterWith(withView: viewstatus)
        
        chatContentview?.anchor(top: viewProfile?.bottomAnchor, leading: scrollConte.leadingAnchor, bottom: scrollConte.bottomAnchor, trailing: scrollConte.trailingAnchor, padding: .init(top: 35, left: 15, bottom: 0, right: 15))
        
        viewUserName?.anchor(top: viewProfile?.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 50 ))
        
        viewUserName?.horizontalCenterWith(withView: viewProfile)
        
        lblFriendName?.anchor(top: viewUserName?.topAnchor, leading: viewUserName?.leadingAnchor, bottom: nil, trailing: viewUserName?.trailingAnchor, padding: .init(top: 15, left: 10, bottom: 15, right: 10))
        
        lblFriendName?.horizontalCenterWith(withView: viewUserName)
        
        tblOptionList?.anchor(top: chatContentview?.topAnchor, leading: chatContentview?.leadingAnchor, bottom: chatContentview?.bottomAnchor, trailing: chatContentview?.trailingAnchor,padding: .init(top: 40, left: 8, bottom: 5, right: 8))
            
        tableHeight()
        
        bottomContentview?.anchor(top: nil, leading: chatContentview?.leadingAnchor, bottom: view.bottomAnchor, trailing: chatContentview?.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 15, right: 0), size: .init(width: 0, height: 64))
        
        lblInputtext?.anchor(top: bottomview?.topAnchor, leading: nil, bottom: bottomview?.bottomAnchor, trailing: nil, padding: .init(top: 15, left: 15 , bottom: 15, right: 15))

        lblInputtext?.horizontalCenterWith(withView: bottomview)
        
        frindProfile?.anchor(top: bottomview?.topAnchor, leading: bottomview?.leadingAnchor, bottom: bottomview?.bottomAnchor, trailing: lblInputtext?.leadingAnchor, padding: .init(top: 5, left: 15, bottom: 5, right: 15), size: .init(width: 45, height: 25))
    }
}


extension ChaatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingCell
        cell.lnlName.text = "sdfsdfs"
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            print("down")
        } else {
            print("up")
        }
    }
    
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//
//        if scrollView == self.scrollView {
//            if yOffset >= scrollViewContentHeight - screenHeight {
//                scrollView.isScrollEnabled = false
//                tableView.scrollEnabled = true
//            }
//        }
//
//        if scrollView == self.tableView {
//            if yOffset <= 0 {
//                self.scrollView.isScrollEnabled = true
//                self.tableView.scrollEnabled = false
//            }
//        }
//    }
    
}
