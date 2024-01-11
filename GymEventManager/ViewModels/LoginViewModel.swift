//
//  SignUpViewModel.swift
//  GymEventManager
//
//  Created by Deep on 10/01/2024.
//

import UIKit

class LoginViewModel {
    
    // MARK: - Observable Properties
    var validEmail: Observable<Bool> = Observable(nil)
    var validPassword: Observable<Bool> = Observable(nil)
    var apiLoading: Observable<Bool> = Observable(nil)
    var errorMessage: Observable<String> = Observable(nil)
    
    // MARK: - properties
    private var email: String?
    private var password: String?
    private let loginAPI = Login()

    // MARK: - Initialization
    init() {
        loginAPI.delegate = self
    }
    
    // MARK: - Validation
    func validated(_ email: String?, _ password: String?) -> Bool {
        validEmail.value = isEmailValid(email ?? "")
        validPassword.value = isPasswordValid(password ?? "")
        
        self.email = email
        self.password = password
        
        return validEmail.value! && validPassword.value!
    }
    
    private func isEmailValid(_ text: String) -> Bool {
        return Validators.validateEmail(text)
    }
    
    private func isPasswordValid(_ text: String) -> Bool {
        return Validators.validatePassword(password: text)
    }
    
    // MARK: - API Call
    func doSignUp() {
        apiLoading.value = true
        User.shared.email = email!
        User.shared.password = password
        loginAPI.postLogin()
    }
    
    private func goToHome() {
        let homeView = HomeViewController.getViewController(storyBoard: "HomeView", viewController: "HomeView")
        let navController = UINavigationController(rootViewController: homeView)
        let appDelegate = UIApplication.shared.delegate as? SceneDelegate
        appDelegate!.window?.rootViewController = navController
    }
}

// MARK: - LoginAPI Delegate
extension LoginViewModel: LoginDelegate {
    
    func didUpdateUser() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.apiLoading.value = false
            self.goToHome()
        }
    }
    
    func didFailUser(_ login: Login) {
        apiLoading.value = false
        errorMessage.value = login.errorMessage
    }
}
