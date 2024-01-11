//
//  ChangePasswordViewController.swift
//  GymEventManager
//
//  Created by Deep on 31/12/2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet private weak var newPasswordErrorLabel: UILabel!
    
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
        newPasswordTextField.rightView = newPasswordTextField.getHidePasswordButton()
        
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = confirmPasswordTextField.getHidePasswordButton()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
