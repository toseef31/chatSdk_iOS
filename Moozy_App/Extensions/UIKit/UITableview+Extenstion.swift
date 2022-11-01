//
//  UITableview+Extenstion.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 13/05/2022.
//

import Foundation
import UIKit

extension UITableView {
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
}
