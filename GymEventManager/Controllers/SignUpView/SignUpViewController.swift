//
//  SignUpViewController.swift
//  GymEventManager
//
//  Created by Deep on 18/12/2023.
//
import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
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
        passwordTextField.rightView = getHidePasswordButton(tag: 0)
        
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = getHidePasswordButton(tag: 0)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func getHidePasswordButton(tag: Int) -> UIButton {
        let rightButton  = UIButton()
        rightButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        rightButton.configuration = UIButton.Configuration.plain()
        rightButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 15,
                                                                           leading: 0,
                                                                           bottom: 15,
                                                                           trailing: 10)
        rightButton.configuration?.buttonSize = UIButton.Configuration.Size.mini
        rightButton.tintColor = .gray
        rightButton.addTarget(self, action: #selector(changePasswordVisibility(_:)), for: .touchUpInside)
        rightButton.tag = tag
        return rightButton
    }
    
    // MARK: - Buttons Actions
    @IBAction private func signUpPressed(_ sender: LoadingButton) {
        dismissKeyboard()
        if validated() {
            sender.showLoading()
            // API Call
            let accessToken = "dummyToken"
            User.shared.accessToken = accessToken
            User.shared.email = emailTextField.text!
            User.shared.name = nameTextField.text
            let homeView = HomeViewController.getViewController(storyBoard: "HomeView", viewController: "HomeView")
            let navController = UINavigationController(rootViewController: homeView)
            let appDelegate = UIApplication.shared.delegate as? SceneDelegate
            appDelegate!.window?.rootViewController = navController
        }
    }
    
    private func validated() -> Bool {
        var success = true
        if let name = nameTextField.text,
           let confirmPassword = confirmPasswordTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text {
            if name.isEmpty {
                nameErrorLabel.isHidden = false
                success = false
            }
            if !Validators.validateEmail(email) {
                emailErrorLabel.isHidden = false
                success = false
            }
            if !Validators.validatePassword(password: password) {
                passwordErrorLabel.isHidden = false
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
    
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func changePasswordVisibility(_ sender: UIButton) {
        var currentTextField: UITextField?
        if sender.tag == 0 {
            currentTextField = passwordTextField
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
