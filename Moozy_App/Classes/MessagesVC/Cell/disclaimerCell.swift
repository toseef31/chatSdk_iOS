//
//  disclaimerCell.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 20/05/2022.
//

import Foundation
import UIKit


class DisclaimerCell: UITableViewCell{
    
    var mainView: UIView?
    var lblTitle: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    
    func configureUI(){
        
        contentView.backgroundColor = UIColor.white
        
        mainView = UIView(backgroundColor: AppColors.outgoingMsgColor, cornerRadius: 10)
        
        lblTitle = UILabel(title: "Messages and calls are end-to-end encrypted. No one outside of this chat, not even Moozy, can read or listen to them.", fontColor: AppColors.primaryColor, alignment: .center, numberOfLines: 0, font: UIFont.font(.Poppins, type: .Regular, size: 12))
        
        mainView?.translatesAutoresizingMaskIntoConstraints = false
        lblTitle!.translatesAutoresizingMaskIntoConstraints = false
        lblTitle!.numberOfLines = 0
        
        addSubview(mainView!)
        mainView?.fillSuperView(padding: .init(top: 1, left: 16, bottom: 1, right: 16))
        mainView?.addSubview(lblTitle!)
        
        lblTitle?.anchor(top: mainView?.topAnchor, leading: mainView?.leadingAnchor, bottom: mainView?.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 1, left: 8, bottom: 1, right: 8))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
