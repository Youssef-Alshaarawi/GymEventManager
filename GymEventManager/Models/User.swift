//
//  User.swift
//  GymEventManager
//
//  Created by Deep on 20/12/2023.
//

import Foundation

struct User: Codable {
    static var shared = User(name: nil, email: "", password: "")
    var name: String?
    var email: String
    var password: String?
    var accessToken: String? {
        didSet {
            UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
        }
    }
    private init(name: String?, email: String, password: String?) {
        self.name = name
        self.email = email
        self.password = password
        self.accessToken = UserDefaults.standard.string(forKey: "accessToken")
    }
}
