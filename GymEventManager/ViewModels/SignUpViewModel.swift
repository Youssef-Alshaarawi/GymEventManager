//
//  SignUpViewModel.swift
//  GymEventManager
//
//  Created by Deep on 10/01/2024.
//

import UIKit

class SignUpViewModel {
    
    // MARK: - Observable Properties
    var validName: Observable<Bool> = Observable(nil)
    var validEmail: Observable<Bool> = Observable(nil)
    var validPassword: Observable<Bool> = Observable(nil)
    var validConfirmPassword: Observable<Bool> = Observable(nil)
    var apiLoading: Observable<Bool> = Observable(nil)
    var errorMessage: Observable<String> = Observable(nil)
    
    // MARK: - properties
    private var name: String?
    private var email: String?
    private var password: String?
    private let signUpAPI = SignUp()

    // MARK: - Initialization
    init() {
        signUpAPI.delegate = self
    }
    
    // MARK: - validation
    func validated(_ name: String?, _ email: String?, _ password: String?, _ confirmPassword: String?) -> Bool {
        validName.value = isNameValid(name ?? "")
        validEmail.value = isEmailValid(email ?? "")
        validPassword.value = isPasswordValid(password ?? "")
        validConfirmPassword.value = doPasswordsMatch(password ?? "", confirmPassword ?? "")
        
        self.name = name
        self.email = email
        self.password = password
        
        return validName.value! && validEmail.value! && validPassword.value! && validConfirmPassword.value!
    }
    
    private func isNameValid(_ text: String) -> Bool {
        return !text.isEmpty
    }
    
    private func isEmailValid(_ text: String) -> Bool {
        return Validators.validateEmail(text)
    }
    
    private func isPasswordValid(_ text: String) -> Bool {
        return Validators.validatePassword(password: text)
    }
    
    private func doPasswordsMatch(_ text1: String, _ text2: String) -> Bool {
        return text1 == text2
    }
    
    // MARK: - API Call
    func doSignUp() {
        apiLoading.value = true
        User.shared.name = name
        User.shared.email = email!
        User.shared.password = password
        signUpAPI.postSignUp()
    }
    
    private func goToHome() {
        let homeView = HomeViewController.getViewController(storyBoard: "HomeView", viewController: "HomeView")
        let navController = UINavigationController(rootViewController: homeView)
        let appDelegate = UIApplication.shared.delegate as? SceneDelegate
        appDelegate!.window?.rootViewController = navController
    }
}

// MARK: - SignUpAPI Delegate
extension SignUpViewModel: SignUpDelegate {
    
    func didUpdateUser() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.apiLoading.value = false
            self.goToHome()
        }
    }
    
    func didFailUser(_ signUp: SignUp) {
        apiLoading.value = false
        errorMessage.value = signUp.errorMessage
    }
}
