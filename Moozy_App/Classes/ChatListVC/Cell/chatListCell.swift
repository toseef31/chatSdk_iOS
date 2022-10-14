//
//  chatListCell.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 26/04/2022.
//

import Foundation
import UIKit
import SDWebImage

class ChatListCell: UITableViewCell{
    
    var mainView: UIView?
    var viewProfile: UIView?
    var lblProfileTitle: UILabel?
    var imgTitle: UIImageView?
    var lblName: UILabel?
    var lblLastMessage: UILabel?
    var lblDate: UILabel?
    var muteImageIcon = UIImageView(image: UIImage(systemName: "speaker.slash")!.withTintColor(AppColors.primaryColor), contentModel: .scaleAspectFill)
    var lblUnreadMessage: UILabel?
    var notificationView: UIView?
    var statusView: UIView?
  
    let view = UIView(backgroundColor: AppColors.primaryColor, cornerRadius: 25)
    var chatData: friendInfoModel? = nil{
        didSet{
            
            let name = chatData?.name.capitalizingFirstLetter() ?? ""
            print(name)
            lblName?.text = name != "" ? name : "No Nameee"
            print(name)
            lblDate?.text =  (chatData?.createdAt.getActualDate()) ?? ""
            statusView?.backgroundColor = chatData?.onlineStatus == 1 ?  #colorLiteral(red: 0, green: 0.8901960784, blue: 0.3725490196, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            let image = chatData?.profile_image ?? nil
            if image != "" && image != nil {
            
                let imgUrl = "\(profileUrl.Url)\(chatData?.profile_image ?? "")" //url
                if let url = URL(string: imgUrl){
                  
                    imgTitle?.sd_setImage(with: url, completed: nil)
                }else {
                    imgTitle?.image = UIImage(named: "profile3")
                }
                lblProfileTitle?.isHidden = true
                imgTitle?.isHidden = false
            }else{
                lblProfileTitle?.text = name != "" ? (name.checkNameLetter()) : "No Name".checkNameLetter()
                imgTitle?.isHidden = true
                lblProfileTitle?.isHidden = false
            }
            self.lblLastMessage?.textColor = chatData?.message ==  "typing..." ?  #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1) : #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)

            if let messageType = chatData?.messageType {
                switch messageType {
                case  0:
                    if chatData?.message == "" {
                        self.lblLastMessage?.text = "Start Chat"
                        break
                    }
                    self.lblLastMessage?.text = "\(chatData?.message ?? "Start Chat")"
                    break
                case  1:
                    self.lblLastMessage?.text = "🖼️ Image"
                    break
                case  2:
                    self.lblLastMessage?.text = "📁 File"
                    break
                case  5:
                    self.lblLastMessage?.text = "🎞️ Video"
                    break
                case  6:
                    self.lblLastMessage?.text = "🎤 Voice"
                    break
                case  7:
                    self.lblLastMessage?.text = "📍 Location"
                    break
                default:
                    break
                }
            }
            if chatData?.ismute  == 1  {
                muteImageIcon.isHidden = false
                }
                else{
                    muteImageIcon.isHidden = true
                   print("not found")
                }
            
             if  chatData?.messageCounter == 0 &&  chatData?.receipt_status == 1  {

                lblUnreadMessage?.text = ""
                notificationView?.isHidden = false
            }
            
           else if chatData?.messageCounter ?? 0 >= 100 {
                    lblUnreadMessage?.text = "99+"
                    notificationView?.isHidden = false
                }
            else if chatData?.messageCounter == 0 &&  chatData?.receipt_status == 0 {
               notificationView?.isHidden = true
            }
          
            else {
                lblUnreadMessage?.text = "\(chatData?.messageCounter ?? 0)"
                notificationView?.isHidden = false
            }
                
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    //MARK: -- Initialized Controls
    func initializedControls(){
       // contentView.backgroundColor = .clear//AppColors.secondaryColor
       
        mainView = UIView(backgroundColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cornerRadius: 20, maskToBounds: true)
        mainView?.addBorder(width: 2, color: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1))
        
        //UIView(backgroundColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cornerRadius: 20, borderColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1), borderWidth: 2 , maskToBounds: true)
        
//        UIView(backgroundColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cornerRadius: 20, borderColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1), borderWidth: 2 , maskToBounds: true)
       
        viewProfile = UIView(cornerRadius: 50/2)
        view.clipsToBounds = true
        
        view.setGradientBackground(frame: CGRect(x: 0, y: 0, width: 50, height: 50), colorLeft: AppGradentColor.colorLeft, colorRight: AppGradentColor.colorRight)
        
        lblProfileTitle = UILabel(fontColor: UIColor.white, alignment: .left, font: UIFont.font(.Poppins, type: .Medium, size: 22))
        
        imgTitle = UIImageView(image: UIImage(named: "profile3")!, contentModel: .scaleAspectFill)
        
        statusView = UIView(backgroundColor: UIColor.green, cornerRadius: 8/2)
        
        lblName = UILabel(fontColor: UIColor.black, alignment: .left, font: UIFont.font(.Roboto, type: .Medium, size: 14))
        
        lblLastMessage = UILabel(fontColor: UIColor.black, alignment: .left, font: UIFont.font(.Muli, type: .none, size: 12))
        
        lblDate = UILabel(fontColor: #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1), alignment: .right, font: UIFont.font(.Roboto, type: .Light, size: 12))
        
        
        notificationView = UIView(backgroundColor: #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1), cornerRadius: 20/2)
        
        lblUnreadMessage = UILabel(fontColor: UIColor.white, alignment: .right, font: UIFont.font(.Muli, type: .Bold, size: 11))
    }
    
    //MARK: -- Setup UI
    func configureUI(){
        initializedControls()
        contentView.addSubview(mainView!)
        notificationView?.constraintsWidhHeight(size: .init(width: 20, height: 20))
        muteImageIcon.constraintsWidhHeight(size: .init(width: 20, height: 20))
        let stacke = UIStackView(views: [notificationView!,muteImageIcon], axis: .horizontal, spacing: 3, distribution: .fillEqually)
        mainView?.addMultipleSubViews(views: viewProfile!, lblDate!, stacke)
        notificationView?.addSubview(lblUnreadMessage!)
        notificationView?.isHidden = true
        viewProfile?.addMultipleSubViews(views: statusView!, view)
        view.addMultipleSubViews(views: imgTitle!, lblProfileTitle!)
        
        mainView?.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 6, left: 0, bottom: 6, right: 0), size: .init(width: 0, height: 85))
        
        viewProfile?.anchor(top: nil, leading: mainView?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: .init(width: 50, height: 50))
        viewProfile?.verticalCenterWith(withView: mainView)
        
        view.fillSuperView()
        
        statusView?.anchor(top: viewProfile?.topAnchor, leading: viewProfile?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 2.5, bottom: 0, right: 0), size: .init(width: 8, height: 8))
        
        lblProfileTitle?.centerSuperView()
        imgTitle?.fillSuperView()
        
        let stack = UIStackView(views: [lblName!, lblLastMessage!], axis: .vertical, spacing: 4, distribution: .fillEqually)
        
        mainView?.addSubview(stack)
        stack.anchor(top: nil, leading: viewProfile?.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        
        stack.verticalCenterWith(withView: mainView)
        
        lblDate?.anchor(top: stack.topAnchor, leading: stack.trailingAnchor, bottom: nil, trailing: mainView?.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10), size: .init(width: 80, height: 0))
        
        stacke.anchor(top: lblDate?.bottomAnchor, leading: nil, bottom: nil, trailing: lblDate?.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        viewProfile?.bringSubviewToFront(statusView!)
        statusView?.bringSubviewToFront(view)
        
        lblUnreadMessage?.centerSuperView()
        imgTitle?.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func layoutSubviews() {
//     super.layoutSubviews()
//     setRemoveSwipeAction()
//    }
//
//    override func layoutIfNeeded() {
//     super.layoutIfNeeded()
//     setRemoveSwipeAction()
//    }
    
}

//extension UITableViewCell {
//
//   var cellActionPullView: UIView? {
//    superview?.subviews
//     .filter{ String(describing: $0).range(of: "UISwipeActionPullView") != nil }
//     .compactMap { $0 }.first
//   }
//
//   func setRemoveSwipeAction() {
//       cellActionPullView?.resizableSnapshotView(from: CGRect(x: 10, y: 10, width: 12, height: 12), afterScreenUpdates: true, withCapInsets: .init(top: 8, left: 8, bottom: 8, right: 8))
////      cellActionPullView?.snp.makeConstraints({ make in
////      make.top.equalTo(self.snp.top).offset(8)
////      make.bottom.equalTo(self.snp.bottom).inset(8)})
//   }
//}
