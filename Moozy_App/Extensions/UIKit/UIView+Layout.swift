//
//  UIView+Layout.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit
import iProgressHUD

extension UIView{
    
    public func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing{

            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    public func centerSuperView(xPadding: CGFloat = 0.0, yPadding: CGFloat = 0.0, size: CGSize = .zero){
       
        translatesAutoresizingMaskIntoConstraints = false
        if let x = superview?.centerXAnchor{
            centerXAnchor.constraint(equalTo: x, constant: xPadding).isActive = true
        }
        
        if let y = superview?.centerYAnchor{
            centerYAnchor.constraint(equalTo: y, constant: yPadding).isActive = true
        }
        
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    public func fillSuperView(padding: UIEdgeInsets = .zero){
        guard let top = superview?.topAnchor, let leading = superview?.leadingAnchor, let trailing = superview?.trailingAnchor, let bottom = superview?.bottomAnchor else {
            return
        }
        anchor(top: top, leading: leading, bottom: bottom, trailing: trailing, padding: padding)
    }
    
    public func horizontalCenterWith(withView: UIView?){
        translatesAutoresizingMaskIntoConstraints = false
        if let x = withView?.centerXAnchor{
            centerXAnchor.constraint(equalTo: x).isActive = true
        }
    }
    
    public func verticalCenterWith(withView: UIView?){
        translatesAutoresizingMaskIntoConstraints = false
        if let y = withView?.centerYAnchor{
            centerYAnchor.constraint(equalTo: y).isActive = true
        }
    }
    
    public func constraintsWidth(width: CGFloat = 0.0){
        translatesAutoresizingMaskIntoConstraints = false
        constraints.filter({$0.firstAttribute == .width}).first?.isActive = false // Remove First if Width Constraints available
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    public func constraintsWithHeight(height: CGFloat = 0.0){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    public func constraintsWidhHeight(size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension UIView{
    func downloadProgressStart(indicatorcolor:UIColor) {
        DispatchQueue.main.async {
            self.isHidden = false
            let iprogress = iProgressHUD()
            iprogress.boxColor = .clear
            iprogress.isShowModal = false
            iprogress.indicatorSize = 100
            iprogress.isShowCaption = false
            iprogress.isTouchDismiss = false
            iprogress.indicatorColor = indicatorcolor
            iprogress.indicatorStyle = .circleStrokeSpin
            iprogress.attachProgress(toViews: self)
            self.showProgress()
        }
    }
    
    func downloadProgressStop() {
        DispatchQueue.main.async {
            self.isHidden = true
            self.dismissProgress()
        }
    }
}
