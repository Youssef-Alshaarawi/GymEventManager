//
//  Validators.swift
//  GymEventManager
//
//  Created by Deep on 19/12/2023.
//

import Foundation
struct Validators {
    static func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
   static func validatePassword(password: String) -> Bool {
       let passwordRegEx = "(?=.*[a-zA-Z]).{8,}"
       let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
       return passwordPred.evaluate(with: password)
   }
}
