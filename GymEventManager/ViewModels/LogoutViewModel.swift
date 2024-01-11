//
//  LogoutViewModel.swift
//  GymEventManager
//
//  Created by Deep on 11/01/2024.
//

import UIKit

class LogoutViewModel {

    // MARK: - Observable Properties
    var errorMessage: Observable<String> = Observable(nil)
    var apiLoading: Observable<Bool> = Observable(nil)
    var success: Observable<Bool> = Observable(nil)
    
    // MARK: - properties
    private let logOutAPI = LogOut()
    
    // MARK: - Initialization
    init() {
        logOutAPI.delegate = self
    }
    
    // MARK: - API Call
    func doLogOut() {
        apiLoading.value = true
        logOutAPI.deleteLogOut()
    }
}

// MARK: - LogOutAPI Delegate
extension LogoutViewModel: LogOutDelegate {
    
    func didUpdateUser() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.apiLoading.value = false
            self.success.value = true
        }
    }
    
    func didFailUser(_ logOut: LogOut) {
        apiLoading.value = false
        errorMessage.value = logOut.errorMessage
    }
}
