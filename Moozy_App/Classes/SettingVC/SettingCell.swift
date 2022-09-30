//
//  SettingCell.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 04/08/2022.
//

import Foundation
import UIKit

class SettingCell: UITableViewCell{
    var onSwitchValueChange: onChangedValue<String>?
    let image = UIImageView(image: UIImage(systemName: "speaker.slash")!, contentModel: .scaleAspectFit)
    
    let lnlName = UILabel(title: "Mute", fontColor: UIColor.black, alignment: .left, font: UIFont.systemFont(ofSize: 12))
    var settingSwitch = UISwitch(backgroundColor: .clear, maskToBounds: true)
    
   
    var setData: chatOptionsModel? = nil{
        didSet{
           
            if setData?.title == "Online Status" {
                image.setImageColor(color: .green)
                settingSwitch.isHidden = false
            }
            else if setData?.title == "Typing" {
                print("typing")
                    image.setImageColor(color: AppColors.primaryColor)
                settingSwitch.isHidden = false
            }
            else{
                image.setImageColor(color: AppColors.primaryColor)
                settingSwitch.isHidden = true
            }
                    image.image = setData?.image ?? nil
                    lnlName.text = setData?.title ?? ""
            
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    func configureUI(){
        image.setImageColor(color: AppColors.primaryColor)
        
        contentView.addMultipleSubViews(views: image, lnlName,settingSwitch)
        settingSwitch.onTintColor = AppColors.primaryColor
        settingSwitch.isHidden = true
        
        image.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 22, height: 22))
        
        image.verticalCenterWith(withView: contentView)
        
        lnlName.anchor(top: nil, leading: image.trailingAnchor, bottom: nil, trailing: settingSwitch.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
        
        settingSwitch.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 12))
        
        settingSwitch.verticalCenterWith(withView: image)
        lnlName.verticalCenterWith(withView: image)
        
        settingSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        
    }
    @objc func switchValueDidChange() {
        if settingSwitch.isOn == true {
             self.onSwitchValueChange?("ON")
               }
               else {
                   self.onSwitchValueChange?("OFF")
               }
     }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
