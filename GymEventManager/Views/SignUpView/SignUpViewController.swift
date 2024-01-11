//
//  SignUpViewController.swift
//  GymEventManager
//
//  Created by Deep on 18/12/2023.
//
import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var signUpButton: LoadingButton!
    @IBOutlet  weak var nameErrorLabel: UILabel!
    @IBOutlet  weak var emailErrorLabel: UILabel!
    @IBOutlet  weak var passwordErrorLabel: UILabel!
    @IBOutlet  weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    
    // MARK: - ViewModel
    var signUpViewModel = SignUpViewModel()
    
    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView() {
        setupTextFields()
        setupDismissKeyboardGesture()
        setupViewModel()
    }
    
    private func setupViewModel() {
        signUpViewModel.validName.bind { [weak self] isValid in
            guard let self = self, let isValid = isValid else { return }
            nameErrorLabel.isHidden = isValid
        }
        signUpViewModel.validEmail.bind { [weak self] isValid in
            guard let self = self, let isValid = isValid else { return }
            emailErrorLabel.isHidden = isValid
        }
        signUpViewModel.validPassword.bind { [weak self] isValid in
            guard let self = self, let isValid = isValid else { return }
            passwordErrorLabel.isHidden = isValid
        }
        signUpViewModel.validConfirmPassword.bind { [weak self] isValid in
            guard let self = self, let isValid = isValid else { return }
            confirmPasswordErrorLabel.isHidden = isValid
        }
        signUpViewModel.apiLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else { return }
            if isLoading {
                signUpButton.showLoading()
            } else {
                signUpButton.hideLoading()
            }
        }
        signUpViewModel.errorMessage.bind { [weak self] error in
            print(error!)
        }
    }
    
    private func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupTextFields() {
        nameTextField.delegate = self
        
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.delegate = self
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = passwordTextField.getHidePasswordButton()
        
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = confirmPasswordTextField.getHidePasswordButton()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Buttons Actions
    @IBAction private func signUpPressed(_ sender: LoadingButton) {
        dismissKeyboard()
        if signUpViewModel.validated(nameTextField.text, emailTextField.text,
                                     passwordTextField.text!, confirmPasswordTextField.text) {
            sender.showLoading()
            signUpViewModel.doSignUp()
        }
    }
    
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - textfieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailErrorLabel.isHidden = true
        } else if textField == passwordTextField {
            passwordErrorLabel.isHidden = true
        } else if textField == nameTextField {
            nameErrorLabel.isHidden = true
        } else {
            confirmPasswordErrorLabel.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.confirmPasswordTextField.becomeFirstResponder()
        case self.nameTextField:
            self.emailTextField.becomeFirstResponder()
        default:
            self.confirmPasswordTextField.resignFirstResponder()
            self.signUpPressed(LoadingButton())
        }
        return true
    }
}
