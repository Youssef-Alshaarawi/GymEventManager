//
//  SignUpViewController.swift
//  GymEventManager
//
//  Created by Deep on 18/12/2023.
//
import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    var currentTextField: UITextField?
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        confirmPasswordTextField.delegate = self
        var rightButton  = UIButton()
        rightButton = initHidePassword(rightButton: rightButton, tag: 0)
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = rightButton
        passwordTextField.textContentType = .oneTimeCode
        rightButton  = UIButton(type: .custom)
        rightButton = initHidePassword(rightButton: rightButton, tag: 1)
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = rightButton
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func initHidePassword(rightButton: UIButton, tag: Int) -> UIButton {
        rightButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        rightButton.configuration = UIButton.Configuration.plain()
        rightButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10)
        rightButton.configuration?.buttonSize = UIButton.Configuration.Size.mini
        rightButton.tintColor = .gray
        rightButton.addTarget(self, action: #selector(changePasswordVisibility(_:)), for: .touchUpInside)
        rightButton.tag = tag
        return rightButton
    }
    // MARK: - Buttons Actions
    @IBAction func signUpPressed(_ sender: LoadingButton) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        var success = true
        if let name = nameTextField.text,
           let confirmPassword = confirmPasswordTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text {
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
            if !Validators.validatePassword(password: password) {
                // error
                passwordErrorLabel.isHidden = false
                success = false
            }
            if confirmPassword != password || confirmPassword.isEmpty {
                confirmPasswordErrorLabel.isHidden = false
                success = false
            }
            // login
            if success {
                sender.showLoading()
                let accessToken = "dummyToken"
                User.shared.accessToken = accessToken
                User.shared.email = email
                User.shared.name = name
                DispatchQueue.main.async {
                    let homeView = UIStoryboard.init(name: "HomeView", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeView") as? HomeViewController
                    let navController = UINavigationController(rootViewController: homeView!)
                    let appDelegate = UIApplication.shared.delegate as? SceneDelegate
                    appDelegate!.window?.rootViewController = navController
                }
            }
        } else {
            // errors and stuff
        }
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func changePasswordVisibility(_ sender: UIButton) {
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
        default: do {
            self.confirmPasswordTextField.resignFirstResponder()
            self.signUpPressed(LoadingButton())
        }
        }
        return true
    }
}
