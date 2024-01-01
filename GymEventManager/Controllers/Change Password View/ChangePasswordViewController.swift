//
//  ChangePasswordViewController.swift
//  GymEventManager
//
//  Created by Deep on 31/12/2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    var currentTextField: UITextField?

    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        var rightButton  = UIButton()
        rightButton = initHidePassword(rightButton: rightButton, tag: 0)
        newPasswordTextField.rightViewMode = .always
        newPasswordTextField.rightView = rightButton
        newPasswordTextField.textContentType = .oneTimeCode
        rightButton  = UIButton(type: .custom)
        rightButton = initHidePassword(rightButton: rightButton, tag: 1)
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = rightButton
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func initHidePassword(rightButton: UIButton, tag: Int) -> UIButton {
        rightButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        rightButton.configuration = UIButton.Configuration.plain()
        rightButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10)
        rightButton.configuration?.buttonSize = UIButton.Configuration.Size.mini
        rightButton.tintColor = .gray
        rightButton.addTarget(self, action: #selector(changePasswordVisibility(_:)), for: .touchUpInside)
        rightButton.tag = tag
        return rightButton
    }
    @objc func changePasswordVisibility(_ sender: UIButton) {
        if sender.tag == 0 {
            currentTextField = newPasswordTextField
        } else {
            currentTextField = confirmPasswordTextField
        }
        currentTextField?.isSecureTextEntry.toggle()
        currentTextField?.resignFirstResponder()
        if currentTextField!.isSecureTextEntry {
            if let image = UIImage(systemName: "eye.fill") {
                sender.setImage(image, for: .normal)
            }
            let realText = currentTextField?.text
            currentTextField?.text = nil
            currentTextField?.insertText(realText ?? "")
        } else {
            if let image = UIImage(systemName: "eye.slash.fill") {
                sender.setImage(image, for: .normal)
            }
        }
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveChangesPressed(_ sender: LoadingButton) {
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        var success = true
        if let confirmPassword = confirmPasswordTextField.text,
           let password = newPasswordTextField.text {
            // validate
            if !Validators.validatePassword(password: password) {
                // error
                newPasswordErrorLabel.isHidden = false
                success = false
            }
            if confirmPassword != password || confirmPassword.isEmpty {
                confirmPasswordErrorLabel.isHidden = false
                success = false
            }
            // login
            if success {
                // sender.showLoading()
            }
        } else {
            // errors and stuff
        }
    }
}
// MARK: - textfieldDelegate
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newPasswordTextField {
            newPasswordErrorLabel.isHidden = true
        } else {
            confirmPasswordErrorLabel.isHidden = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.newPasswordTextField:
            self.confirmPasswordTextField.becomeFirstResponder()
        default: do {
                self.confirmPasswordTextField.resignFirstResponder()
                self.saveChangesPressed(LoadingButton())
            }
        }
        return true
    }
}
