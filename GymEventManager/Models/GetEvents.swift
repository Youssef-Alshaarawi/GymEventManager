//
//  WeatherManager.swift
//  Clima
//
//  Created by Deep on 07/12/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol GetEventsDelegate: AnyObject {
    func didUpdateUser(_ getEvent: GetEvents)
    func didFailUser(_ getEvent: GetEvents)
}

struct GetEvents {
    let gymOwnersURL="https://something.com/gymOwners"
    let token = UserDefaults.standard.string(forKey: "accessToken")
    var delegate: GetEventsDelegate?
    func getEvent() {
        let urlString = "\(gymOwnersURL)/registers"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue( "Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, URLResponse, error in
                if error != nil {
                    delegate?.didFailUser(self)
                    return
                }
                if let response = URLResponse as? HTTPURLResponse {
                    if response.statusCode == 401 {
                        delegate?.didFailUser(self)
                        return
                    }
                }
                if let safeData = data {
                    if parseJSON(userData: safeData) {
                        delegate?.didUpdateUser(self)
                    } else {
                        delegate?.didFailUser(self)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(userData: Data) -> Bool {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(User.self, from: userData)
            let name = decodeData.name
            let email = decodeData.email
            User.shared.name = name
            User.shared.email = email
            User.shared.accessToken = token
            return true
        } catch {
            print("Error decoding response GET Event")
            return false
        }
    }
}
