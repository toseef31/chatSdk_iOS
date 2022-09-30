//
//  activityController.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 29/04/2022.
//

import Foundation
import UIKit

class ActivityController {
    static let shared = ActivityController()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showActivityIndicator(uiView: UIView) {
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.0)
        loadingView.backgroundColor = AppColors.primaryColor.withAlphaComponent(0.9)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = .white
        loadingView.addSubview(activityIndicator)
        activityIndicator.constraintsWidhHeight(size: .init(width: 40, height: 40))
        activityIndicator.centerSuperView()
        container.addSubview(loadingView)
        loadingView.centerSuperView(size: .init(width: 80, height: 80))
        uiView.addSubview(container)
        container.fillSuperView()
        activityIndicator.startAnimating()
    }
    
    //Hide activity indicator
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    //Define UIColor from hex value
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
