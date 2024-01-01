//
//  LogOutSheetViewController.swift
//  GymEventManager
//
//  Created by Deep on 31/12/2023.
//

import UIKit

class LogOutSheetViewController: UIViewController {
    var didTapLogout: (() -> Void)?
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            self?.didTapLogout?()
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        ProfileViewController.logOut = true
        self.dismiss(animated: true)
    }
}
