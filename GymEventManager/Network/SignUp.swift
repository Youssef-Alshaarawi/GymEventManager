//
//  WeatherManager.swift
//  Clima
//
//  Created by Deep on 07/12/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol SignUpDelegate: AnyObject {
    
    func didUpdateUser()
    func didFailUser(_ signUp: SignUp)
}

class SignUp {
    
    private let signUpURL="http://18.219.125.63/gymOwners"
    var delegate: SignUpDelegate?
    var errorMessage: String?
    
    func postSignUp() {
        let urlString = "\(signUpURL)/signup"
        performRequest(urlString: urlString)
    }
    
    private func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            var request = generateRequest(url)
            let task = URLSession.shared.dataTask(with: request) { data, URLResponse, error in
                if error != nil {
                    self.errorMessage = error?.localizedDescription
                    self.delegate?.didFailUser(self)
                    return
                }
                if let response = URLResponse as? HTTPURLResponse {
                    if response.statusCode != 201 {
                        self.failedRequest(data: data)
                        return
                    } else if let safeData = data {
                        self.succeededRequest(safeData)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func failedRequest(data: Data?) {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(ErrorResponse.self, from: data!)
            self.errorMessage = decodeData.error
        } catch {
            print("Error decoding response error POST SignUp")
        }
        self.delegate?.didFailUser(self)
    }
    
    private func succeededRequest(_ data: Data) {
        if self.parseJSON(userData: data) {
            self.delegate?.didUpdateUser()
        } else {
            self.delegate?.didFailUser(self)
        }
    }
    
    private func generateRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = getRequestBody()
        return request
    }
    
    private func getRequestBody() -> Data? {
        let parameters: [String: Any] = [
            "name": User.shared.name!,
            "email": User.shared.email,
            "password": User.shared.password!
        ]
        var body: Data?
        do {
            body = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        return body
    }
    
    private func parseJSON(userData: Data) -> Bool {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(Token.self, from: userData)
            User.shared.accessToken = decodeData.token
            return true
        } catch {
            print("Error decoding response POST SignUp")
            return false
        }
    }
}
