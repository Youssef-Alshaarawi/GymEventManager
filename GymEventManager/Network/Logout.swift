//
//  WeatherManager.swift
//  Clima
//
//  Created by Deep on 07/12/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol LogOutDelegate: AnyObject {
    
    func didUpdateUser()
    func didFailUser(_ logOut: LogOut)
}

class LogOut {
    
    private let logOutURL="http://18.219.125.63/gymOwners"
    var delegate: LogOutDelegate?
    var errorMessage: String?
    
    func deleteLogOut() {
        let urlString = "\(logOutURL)/logout"
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
                    if response.statusCode != 200 {
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
            self.delegate?.didUpdateUser()
    }
    
    private func generateRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue( "Bearer \(String(describing: UserDefaults.standard.string(forKey: "accessToken")!))", forHTTPHeaderField: "Authorization")
        return request
    }
}
