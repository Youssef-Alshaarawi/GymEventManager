//
//  SignUpViewController.swift
//  GymEventManager
//
//  Created by Deep on 18/12/2023.
//
import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet private weak var nameErrorLabel: UILabel!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    
    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView() {
        setupTextFields()
        setupDismissKeyboardGesture()
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
        let nameValid = isNameValid(nameTextField.text ?? "")
        let emailValid = isEmailValid(emailTextField.text ?? "")
        let passwordValid = isPasswordValid(passwordTextField.text ?? "")
        let passwordsMatch = doPasswordsMatch(passwordTextField.text ?? "", confirmPasswordTextField.text ?? "")
        
        return nameValid && emailValid && passwordValid && passwordsMatch
    }
    
    private func isNameValid(_ text: String) -> Bool {
        if text.isEmpty {
            nameErrorLabel.isHidden = false
            return false
        }
        return true
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
    
    private func doPasswordsMatch(_ text1: String, _ text2: String) -> Bool {
        return text1 == text2
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
