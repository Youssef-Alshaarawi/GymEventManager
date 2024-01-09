//
//  LoginViewController.swift
//  GymEventManager
//
//  Created by Deep on 18/12/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView() {
        setupTextFields()
        setupDismissKeyboardGesture()
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
        if validated() {
            sender.showLoading()
            if let token = apiCall() {
                User.shared.accessToken = token
                User.shared.email = emailTextField.text!
                goToHome()
            } else {
                sender.hideLoading()
                // show error
            }
        }
    }
    
    private func goToHome() {
        let homeView = HomeViewController.getViewController(storyBoard: "HomeView", viewController: "HomeView")
        let navController = UINavigationController(rootViewController: homeView)
        let appDelegate = UIApplication.shared.delegate as? SceneDelegate
        appDelegate!.window?.rootViewController = navController
    }
    
    private func apiCall() -> String? {
        return "dummyToken"
    }
    
    private func validated() -> Bool {
        let emailValid = isEmailValid(emailTextField.text ?? "")
        let passwordValid = isPasswordValid(passwordTextField.text ?? "")
        
        return  emailValid && passwordValid
    }
    
    private func isEmailValid(_ text: String) -> Bool {
        if !Validators.validateEmail(text) {
            emailErrorLabel.isHidden = false
            return false
        }
        return true
    }
    
    private func isPasswordValid(_ text: String) -> Bool {
        if !Validators.validatePassword(password: text) {
            passwordErrorLabel.isHidden = false
            return false
        }
        return true
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
