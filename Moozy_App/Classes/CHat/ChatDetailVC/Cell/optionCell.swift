//
//  optionCell.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 28/04/2022.
//

import Foundation
import UIKit

struct chatOptionsModel {
    var image: UIImage?
    var title: String?
   
}

class OptionCallCell: UITableViewCell{
    
    let image = UIImageView(image: UIImage(systemName: "speaker.slash")!, contentModel: .scaleAspectFit)
    
    let lnlName = UILabel(title: "Mute", fontColor: UIColor.black, alignment: .left, font: UIFont.font(.Roboto, type: .Medium, size: 12))
    var ismute = 0
    var ismuted : Int  = 0 {
        didSet {
            ismute = ismuted
        }
    }
    var setData: chatOptionsModel? = nil{
        didSet{
            if setData?.title ?? "" == "Mute Friend" {
                if ismute == 1 {
                    image.image = UIImage(systemName: "speaker.slash") ?? nil
                    lnlName.text = "UnMuteFriend"
                }
                else{
                    image.image = setData?.image ?? nil
                    lnlName.text = setData?.title ?? ""
                   print("not found")
                }
              
                
            }
            else if setData?.title ?? "" ==  "Block Friend" {
                    image.image = setData?.image ?? nil
                    lnlName.text = setData?.title ?? ""
                   print("not found")
                
            }
            
            else {
            image.image = setData?.image ?? nil
            lnlName.text = setData?.title ?? ""
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    func configureUI(){
        
        image.setImageColor(color: AppColors.BlackColor)
        
        contentView.addMultipleSubViews(views: image, lnlName)
        
        image.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 22, height: 22))
        
        image.verticalCenterWith(withView: contentView)
        
        lnlName.anchor(top: nil, leading: image.trailingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
        
        lnlName.verticalCenterWith(withView: image)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
