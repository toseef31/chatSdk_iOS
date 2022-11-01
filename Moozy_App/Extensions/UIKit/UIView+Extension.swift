//
//  UIView+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

public let UIViewDefaultFadeDuration: TimeInterval = 0.4

extension UIView{
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }

}


extension UIView{
    convenience init(backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 0.0, borderColor: CGColor = UIColor.clear.cgColor, borderWidth: CGFloat = 0.0, maskToBounds: Bool = false) {
        self.init()
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = maskToBounds
    }
    
    open func applyShadow(color: CGColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1), shadowOpicity: Float = 1, cornerRadius: CGFloat = 2){
        self.layer.shadowColor = color
        self.layer.shadowOpacity = shadowOpicity
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = cornerRadius
    }
    
    open func addMultipleSubViews(views: UIView...){
        for view in views{
            addSubview(view)
        }
    }
    
    open func roundCorners(_ corners: CACornerMask, _ radius: CGFloat = 5.0, _ borderColor: UIColor = UIColor.clear, _ borderWidth: CGFloat = 0.0) {
        self.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = corners
        } else {
            // Fallback on earlier versions
        }
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}



extension UIView{
    func findSubView<T:UIView>(ofType WhatType:T.Type) -> [T] {
        var result = self.subviews.compactMap {$0 as? T}
        for sub in self.subviews {
            result.append(contentsOf: sub.findSubView(ofType:WhatType))
        }
        return result
    }
}

extension UIView
{
    //Add Corner Radius
    open func roundCorners(corners: UIRectCorner = .allCorners, radius: CGFloat = 0.0, borderColor: UIColor = .clear, borderWidth: CGFloat = 0.0, clipToBonds: Bool = true) {
        clipsToBounds = clipToBonds
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        if corners.contains(.allCorners){
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            return
        }
        
        var maskedCorners = CACornerMask()
        if corners.contains(.topLeft) { maskedCorners.insert(.layerMinXMinYCorner) }
        if corners.contains(.topRight) { maskedCorners.insert(.layerMaxXMinYCorner) }
        if corners.contains(.bottomLeft) { maskedCorners.insert(.layerMinXMaxYCorner) }
        if corners.contains(.bottomRight) { maskedCorners.insert(.layerMaxXMaxYCorner) }
        layer.maskedCorners = maskedCorners
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = false
    }
    
    
    /// Add 4 Sided border
    public func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }

}

//  MARK: TapGuestures
// MARK: Gesture Extensions
extension UIView {
//
//    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addTapGesture(tapNumber: Int = 1, tagId: Int, action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        tag = tagId
    }

}
///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
open class BlockTap: UITapGestureRecognizer {
    private var tapAction: ((UITapGestureRecognizer) -> Void)?
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    public convenience init (
        tapCount: Int = 1,
        fingerCount: Int = 1,
        action: ((UITapGestureRecognizer) -> Void)?) {
        self.init()
        self.numberOfTapsRequired = tapCount
        
        #if os(iOS)
        
        self.numberOfTouchesRequired = fingerCount
        
        #endif
        
        self.tapAction = action
        self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
    }
    
    @objc open func didTap (_ tap: UITapGestureRecognizer) {
        tapAction? (tap)
    }
}

extension UIView{
    public func addGrandient(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
//        gradient.locations = [0.0, 1.0]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        return gradient
    }
}



class emptyView: UIView{
    
    var btnAddItem : UILabel?
    var backGroundImage : UIImageView?
    var backGroundImage2 : UIImageView?
    var title: String
    var image: UIImage?
    var lblTitle: UILabel?
    
    init(title: String = "", image: UIImage? = nil ,   frame: CGRect = .zero) {
        self.title = title
        self.image = image
        
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI(){
        btnAddItem = UILabel(title: title, fontColor: AppColors.BlackColor, alignment: .center, numberOfLines: 1, font: UIFont.font(.Roboto, type: .Medium, size: 26), underLine: false)
        backGroundImage = UIImageView(image: UIImage(named: "Chat_BG")!, contentModel: .scaleAspectFit)
        backGroundImage2 = UIImageView(image: UIImage(named: "Group")!, contentModel: .scaleAspectFit)
        
        if image != nil{
            
            backGroundImage?.image = image
            addMultipleSubViews(views: backGroundImage2!, backGroundImage!)
            addSubview(backGroundImage!)
            
            backGroundImage?.constraintsWidhHeight(size: .init(width:  350, height:  350))
            
            backGroundImage?.centerSuperView()
            backGroundImage2?.constraintsWidhHeight(size: .init(width:  200, height:  20))
            
            backGroundImage2?.centerSuperView()
        }
        else {
            addSubview(btnAddItem!)
            btnAddItem?.centerSuperView()
        }
       
        
    }
    
}
