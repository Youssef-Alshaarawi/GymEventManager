//
//  UIViewController+Extension.swift
//  GymEventManager
//
//  Created by Deep on 03/01/2024.
//

import UIKit

extension UIViewController {
    static func getViewController(storyBoard: String, viewController: String) -> Self {
        return UIStoryboard.init(name: storyBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: viewController) as! Self 
    }
}
