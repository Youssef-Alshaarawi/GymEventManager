//
//  UITextField+Extension.swift
//  GymEventManager
//
//  Created by Deep on 09/01/2024.
//

import UIKit

extension UITextField {
    func getHidePasswordButton() -> UIButton {
        let rightButton  = UIButton()
        rightButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        rightButton.tintColor = .gray
        rightButton.configuration = UIButton.Configuration.plain()
        rightButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 15,
                                                                           leading: 0,
                                                                           bottom: 15,
                                                                           trailing: 10)
        rightButton.configuration?.buttonSize = UIButton.Configuration.Size.mini
        rightButton.addTarget(self, action: #selector(changePasswordVisibility(_:)), for: .touchUpInside)
        return rightButton
    }
    
    @objc private func changePasswordVisibility(_ sender: UIButton) {
        self.isSecureTextEntry.toggle()
        let imageName = self.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
