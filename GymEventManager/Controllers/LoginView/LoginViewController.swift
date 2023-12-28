//
//  LoginViewController.swift
//  GymEventManager
//
//  Created by Deep on 18/12/2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.isNavigationBarHidden = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        let rightButton  = UIButton()
        rightButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        rightButton.tintColor = .gray
        rightButton.configuration = UIButton.Configuration.plain()
        rightButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10)
        rightButton.configuration?.buttonSize = UIButton.Configuration.Size.mini
        rightButton.addTarget(self, action: #selector(changePasswordVisibility(_:)), for: .touchUpInside)
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = rightButton
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
// MARK: - Buttons Actions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func loginPressed(_ sender: LoadingButton) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        var success = true
        if let email = emailTextField.text, let password = passwordTextField.text {
            // validate
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
            // login
            if success {
                sender.showLoading()
                let accessToken = "dummyToken"
                User.shared.accessToken = accessToken
                DispatchQueue.main.async {
                    let homeView = UIStoryboard.init(name: "HomeView", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeView") as? HomeViewController
                    self.navigationController?.setViewControllers([homeView!], animated: true)
                }
            }
        } else {
            // errors and stuff
        }
    }
    @IBAction func createAccountPressed(_ sender: UIButton) {
        let signUPView = UIStoryboard.init(name: "SignUpView", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpView") as? SignUpViewController
        self.navigationController?.pushViewController(signUPView!, animated: true)
    }
    @objc func changePasswordVisibility(_ sender: UIButton) {
        passwordTextField.resignFirstResponder()
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
}
