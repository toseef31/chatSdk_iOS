//
//  popupAttachment.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

class PopUpAttachment: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    var popView: UIView?
    var tblAttachment: UITableView?
    var btnClose: MoozyActionButton?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func initializedControls(){
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3989755682)
        
        configureTableView()
        popView = UIView(backgroundColor: UIColor.white, cornerRadius: 15)
        btnClose = MoozyActionButton(image: UIImage(systemName: "xmark"), backgroundColor: UIColor.white, cornerRadius: 60/2, imageSize: .init(width: 20, height: 20)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: btnClose!, popView!)
        popView?.addSubview(tblAttachment!)
        
        btnClose?.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 8), size: .init(width: 60, height: 60))
        
        popView?.anchor(top: nil, leading: view.leadingAnchor, bottom: btnClose?.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 8, right: 8), size: .init(width: 0, height: 580))
        
        tblAttachment?.fillSuperView(padding: .init(top: 8, left: 12, bottom: 0, right: 12))
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

extension PopUpAttachment: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConstantStrings.attacments.attacmentsname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AttachmentCell
        cell.dataSet = ConstantStrings.attacments.attacmentsname[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let index = indexPath.row
        switch index{
        case 0:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            break
        case 1:
            openGallery()
            break
        case 2:
            break
        case 3:
            break
        default :
            break
        }
    }
    
    func openGallery()
   {
       if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.allowsEditing = true
           imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
           self.present(imagePicker, animated: true, completion: nil)
       }
       else
       {
           let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    }
   
}

extension PopUpAttachment{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        // Set photoImageView to display the selected image.
//           SimageView.image = selectedImage

        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}

class AttachmentCell: UITableViewCell {

    var containerView: UIView?
    var img: UIImageView?
    var lblName: UILabel?
    var stack: UIStackView?
    
    let seperatorLine = UIView(backgroundColor: #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1))
    
    var dataSet: attacmentArr? = nil{
        didSet{
            img?.image = dataSet?.img ?? nil
            lblName?.text = dataSet?.name ?? ""
            img?.tintColor = AppColors.primaryColor
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        configureUI()
    }
    
    func initializedControls(){
        
        containerView = UIView(backgroundColor: UIColor.white, maskToBounds: true)
        
        img = UIImageView(image: UIImage(named: "logo")!, contentModel: .scaleAspectFit)
        img?.image = img?.image?.withRenderingMode(.alwaysTemplate)
        img?.tintColor = AppColors.primaryColor
        
        lblName = UILabel(title: "Title Name", fontColor: #colorLiteral(red: 0.1843137255, green: 0.1803921569, blue: 0.1803921569, alpha: 1), alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 16))
    }
    
    func configureUI(){
        initializedControls()
        
        contentView.addSubview(containerView!)
        containerView?.addMultipleSubViews(views: img!, lblName!, seperatorLine)
        
        containerView?.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 4, left: 4, bottom: 4, right: 4), size: .init(width: 0, height: 45))
        
        img?.anchor(top: nil, leading: containerView?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 20, height: 20))
        
        lblName?.anchor(top: nil, leading: img?.trailingAnchor, bottom: nil, trailing: containerView?.trailingAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 8))
        
        img?.verticalCenterWith(withView: containerView!)
        lblName?.verticalCenterWith(withView: containerView!)
        
        seperatorLine.anchor(top: nil, leading: containerView?.leadingAnchor, bottom: containerView?.bottomAnchor, trailing: containerView?.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
