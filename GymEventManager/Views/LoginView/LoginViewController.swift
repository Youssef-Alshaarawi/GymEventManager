//
//  LoginViewController.swift
//  GymEventManager
//
//  Created by Deep on 18/12/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var loginButton: LoadingButton!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    // MARK: - ViewModel
    var loginViewModel = LoginViewModel()
    
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
        loginViewModel.validEmail.bind { [weak self] isValid in
            guard let self = self, let isValid = isValid else { return }
            emailErrorLabel.isHidden = isValid
        }
        loginViewModel.validPassword.bind { [weak self] isValid in
            guard let self = self, let isValid = isValid else { return }
            passwordErrorLabel.isHidden = isValid
        }
        loginViewModel.apiLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else { return }
            if isLoading {
                loginButton.showLoading()
            } else {
                loginButton.hideLoading()
            }
        }
        loginViewModel.errorMessage.bind { [weak self] error in
            guard let self = self, let error = error else { return }
            print(error)
        }
    }
    
    private func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupTextFields() {
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.delegate = self
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = passwordTextField.getHidePasswordButton()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Buttons Actions
    @IBAction private func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func loginPressed(_ sender: LoadingButton) {
        dismissKeyboard()
        if loginViewModel.validated(emailTextField.text,
                                     passwordTextField.text!) {
            sender.showLoading()
            loginViewModel.doSignUp()
        }
    }
    
   @IBAction private func createAccountPressed(_ sender: UIButton) {
        let signUPView = SignUpViewController.getViewController(storyBoard: "SignUpView", viewController: "SignUpView")
        self.navigationController?.pushViewController(signUPView, animated: true)
    }
}

// MARK: - textfieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailErrorLabel.isHidden = true
        }
        if textField == passwordTextField {
            passwordErrorLabel.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        default:
            self.passwordTextField.resignFirstResponder()
            self.loginPressed(LoadingButton())
        }
        return true
    }
}
