//
//  UITextView+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 13/05/2022.
//

import Foundation
import UIKit

extension UITextView {
    
    func numberOfLines() -> Int{
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
}



