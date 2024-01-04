//
//  LoginViewController.swift
//  GymEventManager
//
//  Created by Deep on 18/12/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
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
        passwordTextField.rightView = getHidePasswordButton()
    }
    
    private func getHidePasswordButton() -> UIButton {
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
            // Api Call
            let accessToken = "dummyToken"
            User.shared.accessToken = accessToken
            User.shared.email = emailTextField.text!
            let homeView = HomeViewController.getViewController(storyBoard: "HomeView", viewController: "HomeView")
            let navController = UINavigationController(rootViewController: homeView)
            let appDelegate = UIApplication.shared.delegate as? SceneDelegate
            appDelegate!.window?.rootViewController = navController
        }
    }
    
    private func validated() -> Bool {
        var success = true
        if let email = emailTextField.text, let password = passwordTextField.text {
            if !Validators.validateEmail(email) {
                emailErrorLabel.isHidden = false
                success = false
            }
            if !Validators.validatePassword(password: password) {
                passwordErrorLabel.isHidden = false
                success = false
            }
        } else {
            success = false
        }
        return success
    }

    @IBAction private func createAccountPressed(_ sender: UIButton) {
        let signUPView = SignUpViewController.getViewController(storyBoard: "SignUpView", viewController: "SignUpView")
        self.navigationController?.pushViewController(signUPView, animated: true)
    }
    
    @objc private func changePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            if let image = UIImage(systemName: "eye.fill") {
                sender.setImage(image, for: .normal)
            }
            let realText = passwordTextField.text
            passwordTextField.text = nil
            passwordTextField.insertText(realText ?? "")
        } else {
            if let image = UIImage(systemName: "eye.slash.fill") {
                sender.setImage(image, for: .normal)
            }
        }
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
