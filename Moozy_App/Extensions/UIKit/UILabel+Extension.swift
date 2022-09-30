//
//  UILabel+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation
import UIKit

extension UILabel{
    convenience public init(
        title: String = "",
        fontColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        font: UIFont = .systemFont(ofSize: 18),
        underLine: Bool = false
       ) {
        self.init()
        if underLine{
//            self.attributedText  = title.underLined
        }else{
            self.text = title
        }
        
        self.textColor = fontColor
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        self.font = font
    }
}

extension UILabel {
    func setSpannedColor (fullText : String , changeText : String, color: UIColor) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = attribute
    }
}


extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
    func hideMidChars(value: String) -> String {
        let components = value.components(separatedBy: "@")
        var hidingEmail = ""
        hidingEmail = String(components.first!.enumerated().map { index, char in
            return [0, 1, components.first!.count - 1, components.first!.count - 2].contains(index) ? char : "*"
       })
        return hidingEmail+"@"+components.last!
    }
}

extension String {

    func NSRange(of substring: String) -> NSRange? {
        // Get the swift range
        guard let range = range(of: substring) else { return nil }

        // Get the distance to the start of the substring
        let start = distance(from: startIndex, to: range.lowerBound) as Int
        //Get the distance to the end of the substring
        let end = distance(from: startIndex, to: range.upperBound) as Int

        //length = endOfSubstring - startOfSubstring
        //start = startOfSubstring
        return NSMakeRange(start, end - start)
    }

}

extension UILabel {
  func addCharacterSpacing(kernValue: Double = 1.0) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
