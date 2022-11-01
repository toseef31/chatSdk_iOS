//
//  UIView+Stack.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

extension UIStackView{

    convenience init(views: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0.0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    
    open func addSubViews(views: [UIView]){
        for view in views{
            addSubview(view)
        }
    }
    
    open func addSubViewAt(view: UIView, index: Int){
        insertSubview(view, at: index)
    }
    
    open func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    open func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}

class AppShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = AppColors.primaryColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20.0
        self.layer.borderColor = AppColors.primaryColor.cgColor
        self.layer.borderWidth = 0.0
    }
}

class AppShadowCellView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = AppColors.primaryColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = AppColors.primaryColor.cgColor
        self.layer.borderWidth = 0.5
    }
}

extension UIView {

    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

}

extension UIView {
    
    var width:CGFloat {
        return self.frame.size.width
    }
    var height:CGFloat {
        return self.frame.size.height
    }
    var xPos:CGFloat {
        return self.frame.origin.x
    }
    var yPos:CGFloat {
        return self.frame.origin.y
    }

    func applyContainerShadowA() {
        self.layer.masksToBounds = false
        self.layer.shadowColor =  AppColors.shadoColor.cgColor //UIColor(red: 0.824, green: 0.824, blue: 0.824, alpha: 0.5).cgColor
       // self.layer.shadowOffset = CGSize(width: 0, height: -8)
        self.layer.shadowRadius = 41
        self.layer.shadowOpacity = 1
        
        
    }
    
    func applyContainerShadowB() {
        self.layer.masksToBounds = false
        self.layer.shadowColor =  AppColors.shadoColor.cgColor //UIColor(red: 0.824, green: 0.824, blue: 0.824, alpha: 0.5).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -8)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.3
        
        
    }
    

    func applyBottomShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.1
    }
    func FriendsBottomShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 12)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.02
    }
    func setGradientBackground(frame : CGRect, colorLeft: UIColor ,colorRight : UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft.cgColor, colorRight.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
