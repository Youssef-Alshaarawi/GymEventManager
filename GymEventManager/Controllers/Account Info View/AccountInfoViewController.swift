//
//  AccountInfoViewController.swift
//  GymEventManager
//
//  Created by Deep on 28/12/2023.
//

import UIKit

class AccountInfoViewController: UIViewController {
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: LoadingButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        nameTextField.text = User.shared.name
        emailTextField.text = User.shared.email
        emailTextField.keyboardType = .emailAddress
    }
    // MARK: - Buttons Methods
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: LoadingButton) {
        emailTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        var success = true
        if let name = nameTextField.text,
           let email = emailTextField.text {
            // validate
            if name.isEmpty {
                nameErrorLabel.isHidden = false
                success = false
            }
            if !Validators.validateEmail(email) {
                // error
                emailErrorLabel.isHidden = false
                success = false
            }
            // login
            if success {
                // sender.showLoading()
                User.shared.name = nameTextField.text
                User.shared.email = emailTextField.text!
                saveButton.isHidden = true
                editButton.isHidden = false
                changeTextFieldState(nameTextField)
                changeTextFieldState(emailTextField)
            }
        } else {
            // errors and stuff
        }
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        saveButton.isHidden = false
        editButton.isHidden = true
        changeTextFieldState(nameTextField)
        changeTextFieldState(emailTextField)
    }
    func changeTextFieldState(_ textField: UITextField) {
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
        default: do {
            self.emailTextField.resignFirstResponder()
            self.saveButtonPressed(LoadingButton())
        }
        }
        return true
    }
}
