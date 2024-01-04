//
//  LogOutSheetViewController.swift
//  GymEventManager
//
//  Created by Deep on 31/12/2023.
//

import UIKit

class LogOutSheetViewController: UIViewController {
    
    // MARK: - Actions
    var didTapLogout: (() -> Void)?
    
    @IBAction private func logOutPressed(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            self?.didTapLogout?()
        }
    }
    
    @IBAction private func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
