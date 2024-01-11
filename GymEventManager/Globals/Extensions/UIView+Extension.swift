//
//  UIView+Extension.swift
//  GymEventManager
//
//  Created by Deep on 25/12/2023.
//

import UIKit

extension UIView {
    
    @IBInspectable
     var cornerRadius: CGFloat {
         get {
             return layer.cornerRadius
         }
         set {
             layer.cornerRadius = newValue
         }
     }
}
