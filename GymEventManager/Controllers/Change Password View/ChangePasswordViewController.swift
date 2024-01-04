//
//  ChangePasswordViewController.swift
//  GymEventManager
//
//  Created by Deep on 31/12/2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    
    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView() {
        setupTextField()
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupTextField() {
        newPasswordTextField.delegate = self
        newPasswordTextField.rightViewMode = .always
        newPasswordTextField.rightView = getHidePasswordButton(tag: 0)
        
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = getHidePasswordButton(tag: 1)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func getHidePasswordButton(tag: Int) -> UIButton {
        var rightButton  = UIButton()
        rightButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        rightButton.configuration = UIButton.Configuration.plain()
        rightButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10)
        rightButton.configuration?.buttonSize = UIButton.Configuration.Size.mini
        rightButton.tintColor = .gray
        rightButton.addTarget(self, action: #selector(changePasswordVisibility(_:)), for: .touchUpInside)
        rightButton.tag = tag
        return rightButton
    }
    
    @objc private func changePasswordVisibility(_ sender: UIButton) {
        var currentTextField: UITextField?
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
    
    // MARK: - Actions
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func saveChangesPressed(_ sender: LoadingButton) {
        dismissKeyboard()
        if validated() {
            // sender.showLoading()
            // Api call
        }
        
    }
    
    private func validated() -> Bool {
        var success = true
        if let confirmPassword = confirmPasswordTextField.text,
           let password = newPasswordTextField.text {
            if !Validators.validatePassword(password: password) {
                newPasswordErrorLabel.isHidden = false
                success = false
            }
            if confirmPassword != password || confirmPassword.isEmpty {
                confirmPasswordErrorLabel.isHidden = false
                success = false
            }
        } else {
            success = false
        }
        return success
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
        default:
            self.confirmPasswordTextField.resignFirstResponder()
            self.saveChangesPressed(LoadingButton())
        }
        return true
    }
}
