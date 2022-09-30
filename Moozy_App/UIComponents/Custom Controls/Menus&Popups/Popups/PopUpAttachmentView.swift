//
//  PopUpAttachmentView.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 17/05/2022.
//

import Foundation
import UIKit
import SwiftUI

class PopUpAttachmentView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    var popView: UIView?
    var lblTitle: UILabel?
    var tblAttachment: UITableView?
    var btnClose: MoozyActionButton?
    var imagePicker: UIImagePickerController!
    
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func initializedControls(){
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        
        configureTableView()
        popView = UIView(backgroundColor: UIColor.white, cornerRadius: 15)
        
        lblTitle = UILabel(title: "Attach", fontColor: AppColors.primaryColor, alignment: .center, font: UIFont.font(.Poppins, type: .Regular, size: 16))
        
        btnClose = MoozyActionButton(image: UIImage(systemName: "xmark"), backgroundColor: UIColor.white, cornerRadius: 60/2, imageSize: .init(width: 20, height: 20)) {
            self.dismiss(animated: true, completion: nil)
        }
        btnClose?.tint = #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1)
    }
    
    func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: blurEffectView, btnClose!, popView!)
        popView?.addMultipleSubViews(views: lblTitle!, btnClose!, tblAttachment!)
        
        popView?.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 340))
        
        btnClose?.anchor(top: popView?.topAnchor, leading: nil, bottom: nil, trailing: popView?.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 8), size: .init(width: 50, height: 50))
        
        lblTitle?.horizontalCenterWith(withView: popView!)
        lblTitle?.verticalCenterWith(withView: btnClose!)
        
        tblAttachment?.anchor(top: btnClose?.bottomAnchor, leading: popView?.leadingAnchor, bottom: popView?.bottomAnchor, trailing: popView?.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    func configureTableView(){
        tblAttachment = UITableView()
        tblAttachment?.register(AttachmentCell.self, forCellReuseIdentifier: "Cell")
        tblAttachment?.delegate = self
        tblAttachment?.dataSource = self
        tblAttachment?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tblAttachment?.separatorStyle = .none
        tblAttachment?.isScrollEnabled = false
    }
}

extension PopUpAttachmentView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConstantStrings.attacments.attacmentsname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AttachmentCell
        cell.dataSet = ConstantStrings.attacments.attacmentsname[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        self.dismiss(animated: true, completion: nil)
//        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .selectAttachmentAction, object: nil, userInfo: ["select": index])
//        }
    }
    
    func openGallery()
    {
        let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

