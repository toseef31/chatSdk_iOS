////
////  locationMsgCell.swift
////  Chat_App
////
////  Created by Ali Abdullah on 19/04/2022.
////
//
//import Foundation
//import UIKit
//import SwipyCell
//import MapKit
//
//import GoogleMaps
//import GooglePlaces
//
////import MKCoordinateSpan
//class LocationMsgCell: UITableViewCell ,  MKMapViewDelegate {
//
//    //var mapView = MKMapView()
//  //  var mapView = GMSMapView()
//   // Set initial location in Honolulu
//   let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//
//   var locationView: UIImageView?
//   var blurView: UIView?
//   var mainView: UIView?
//   var statusView: UIImageView?
//   var lblDatetTimeDay: UILabel?
//
//   var stack: UIStackView?
//
//   var leadingConstraint: NSLayoutConstraint!
//   var trailingConstraint: NSLayoutConstraint!
//
//   var stackLeadingConstraint: NSLayoutConstraint!
//   var stackTrailingConstraint: NSLayoutConstraint!
//
//
//    var imgSendSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
//    var imgRecivedSlected = UIImageView(image: #imageLiteral(resourceName: "Oval3x"), contentModel: .scaleAspectFit)
//    var stackeContent : UIStackView?
//    var isdelForward: Bool? = false
//    var isSmsSelected: Bool?  = false
//
//   var chatData: chat_data? = nil {
//       didSet {
//
//           mainView?.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9803921569, blue: 1, alpha: 1) //.white
//
//           var decMessage = ""
//           let msg = chatData?.message ?? ""+""
//           let key = chatData?.senderId._id ?? ""  // length == 32
//           let test = ""
//           var  ivStr = key + test
//           let halfLength = 16 //receiverId.count / 2
//           let index1 = ivStr.index(ivStr.startIndex, offsetBy: halfLength)
//           ivStr.insert("-", at: index1)
//           let result = ivStr.split(separator: "-")
//           let iv = String(result[0])
//           let s =  msg
//           print("my sec id is auvc \(s)")
//           do{
//               decMessage = try s.aesDecrypt(key: key, iv: iv)
//           }catch( let error ){
//               print(error)}
//           let imageChat = AppUtils.shared.loadImage(fileName: decMessage)
//           if imageChat != nil{
//
//               locationView?.image = imageChat
//
//           }
//           else{
//               print("Download Error")
//           }
//
//           lblDatetTimeDay?.text = getMsgDate(date: chatData?.createdAt ?? "")
//
//           if chatData?.receipt_status == 0{
//               statusView?.image = UIImage(systemName: "clock")
//           }else{
//               if chatData?.seen == 0 && chatData?.receipt_status == 1 {
//                   statusView?.image = UIImage(systemName: "checkmark")
//               }else{
//                   statusView?.image = UIImage(named: "seen_double_check")
//                   statusView?.setImageColor(color: AppColors.primaryColor)
//               }
//           }
//
//           if  isSmsSelected == true {
//               imgSendSlected.image = #imageLiteral(resourceName: "select2x")
//               imgRecivedSlected.image = #imageLiteral(resourceName: "select2x")
//           } else {
//               imgSendSlected.image = #imageLiteral(resourceName: "Oval3x")
//               imgRecivedSlected.image = #imageLiteral(resourceName: "Oval3x")
//
//           }
//
//           if chatData?.receiverId == AppUtils.shared.senderID {
//               leadingConstraint.isActive = true
//               trailingConstraint.isActive = false
//
//               stackLeadingConstraint.isActive = true
//               stackTrailingConstraint.isActive = false
//               mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 30, clipToBonds: true)
//               locationView?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 30, clipToBonds: true)
//               statusView?.isHidden = true
//
//               if isdelForward! {
//                   imgRecivedSlected.isHidden = true
//               imgSendSlected.isHidden = false
//               }  else {
//                   imgRecivedSlected.isHidden = true
//                   imgSendSlected.isHidden = true
//               }
//
//
//           } else {
//               leadingConstraint.isActive = false
//               trailingConstraint.isActive = true
//
//               stackLeadingConstraint.isActive = false
//               stackTrailingConstraint.isActive = true
//
//               mainView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 30, clipToBonds: true)
//               locationView?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 30, clipToBonds: true)
//               statusView?.isHidden = false
//               if isdelForward! {
//                   imgRecivedSlected.isHidden = false
//                   imgSendSlected.isHidden = true
//               }  else {
//                   imgRecivedSlected.isHidden = true
//                   imgSendSlected.isHidden = true
//               }
//
//           }
//       }
//   }
//
//   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//       super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//       backgroundColor = .clear
//       configureUI()
//       mainView?.backgroundColor = .white
//   }
//
//   //Initialized Controls
//   func initializedControls(){
//
//       locationView = UIImageView(image: UIImage(named: "placeholder")!, contentModel: .scaleAspectFill)
//
//       blurView = UIView()
//
//       mainView = UIView(cornerRadius: 20)
//
//       statusView = UIImageView(image: UIImage(systemName: "checkmark")!, contentModel: .scaleAspectFill)
//       statusView?.setImageColor(color: AppColors.primaryColor)
//       lblDatetTimeDay = UILabel(title: "12:50 (Fri)", fontColor: UIColor.gray, alignment: .left, font: UIFont.systemFont(ofSize: 12))
//
//       mainView?.translatesAutoresizingMaskIntoConstraints = false
//       locationView?.translatesAutoresizingMaskIntoConstraints = false
//       locationView?.layer.cornerRadius = 30
//       locationView?.layer.masksToBounds = true
//
//       blurView?.backgroundColor = .clear
//       statusView?.constraintsWidhHeight(size: .init(width: 12, height: 12))
//       stack = UIStackView(views: [lblDatetTimeDay!,statusView!], axis: .horizontal, spacing: 5, distribution: .fill)
//   }
//
//   //ConfigureUI
//   func configureUI(){
//       initializedControls()
//       imgSendSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
//       imgRecivedSlected.constraintsWidhHeight(size: .init(width: 15, height: 15))
//       mainView?.constraintsWidhHeight(size: .init(width: 250, height: 220))
//
//        stackeContent = UIStackView(views: [imgSendSlected,mainView!,imgRecivedSlected], axis: .horizontal, spacing: 3, distribution: .fill)
//
//       imgRecivedSlected.isHidden = true
//           imgSendSlected.isHidden = true
//
//       contentView.addSubview(stackeContent!)
//       contentView.addSubview(stack!)
//       mainView?.addMultipleSubViews(views: locationView!)
//       locationView?.addSubview(blurView!)
//
//       stackeContent?.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 280, height: 220))
//
//       locationView?.fillSuperView(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
//
//       blurView?.fillSuperView()
//
//       stack?.anchor(top: mainView?.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: mainView?.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 8, right: 0))
//
//
//       leadingConstraint = stackeContent!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
//       leadingConstraint.isActive = false
//
//       trailingConstraint = stackeContent!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
//       trailingConstraint.isActive = true
//
//       stackLeadingConstraint = stack?.leadingAnchor.constraint(equalTo: mainView!.leadingAnchor, constant: 1)
//       stackLeadingConstraint.isActive = false
//
//       stackTrailingConstraint = stack?.trailingAnchor.constraint(equalTo: mainView!.trailingAnchor, constant: -1)
//       stackTrailingConstraint.isActive = false
//   }
//
//   required init?(coder aDecoder: NSCoder) {
//       fatalError("init(coder:) has not been implemented")
//   }
//}
