//
//  AccountInfoViewController.swift
//  GymEventManager
//
//  Created by Deep on 28/12/2023.
//

import UIKit

class AccountInfoViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: LoadingButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        setupTextFields()
    }
    
    private func setupTextFields() {
        nameTextField.delegate = self
        nameTextField.text = User.shared.name
        
        emailTextField.delegate = self
        emailTextField.text = User.shared.email
        emailTextField.keyboardType = .emailAddress
    }
    
    // MARK: - Buttons Methods
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func saveButtonPressed(_ sender: LoadingButton) {
        view.endEditing(true)
            if validated() {
                // sender.showLoading()
                // Api Call
                User.shared.name = nameTextField.text
                User.shared.email = emailTextField.text!
                saveButton.isHidden = true
                editButton.isHidden = false
                changeTextFieldState(nameTextField)
                changeTextFieldState(emailTextField)
            }
        }
    
    private func validated() -> Bool {
        var success = true
        if let name = nameTextField.text,
           let email = emailTextField.text {
            if name.isEmpty {
                nameErrorLabel.isHidden = false
                success = false
            }
            if !Validators.validateEmail(email) {
                emailErrorLabel.isHidden = false
                success = false
            } else {
                success = false
            }
        }
        return success
    }
    
    @IBAction private func editButtonPressed(_ sender: UIButton) {
        saveButton.isHidden = false
        editButton.isHidden = true
        changeTextFieldState(nameTextField)
        changeTextFieldState(emailTextField)
    }
    
    private func changeTextFieldState(_ textField: UITextField) {
        if !textField.isEnabled {
            textField.isEnabled = true
            textField.backgroundColor = .white
        } else {
            textField.isEnabled = false
            textField.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        }
    }
}

// MARK: - textfieldDelegate
extension AccountInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailErrorLabel.isHidden = true
        } else {
            nameErrorLabel.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameTextField:
            self.emailTextField.becomeFirstResponder()
        default:
            self.emailTextField.resignFirstResponder()
            self.saveButtonPressed(LoadingButton())
        }
        return true
    }
}
