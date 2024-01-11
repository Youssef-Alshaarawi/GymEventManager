//
//  LogOutSheetViewController.swift
//  GymEventManager
//
//  Created by Deep on 31/12/2023.
//

import UIKit

class LogOutSheetViewController: UIViewController {
    @IBOutlet weak var logOutButton: LoadingButton!
    
    // MARK: - ViewModel
    var logOutViewModel = LogoutViewModel()
    
    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        setupViewModel()
    }
    
    private func setupViewModel() {
        logOutViewModel.apiLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else { return }
            if isLoading {
                logOutButton.showLoading()
            } else {
                logOutButton.hideLoading()
            }
        }
        logOutViewModel.errorMessage.bind { [weak self] error in
            guard let self = self, let error = error else { return }
            print(error)
        }
        logOutViewModel.success.bind { [weak self] isSuccess in
            guard let self = self, let isSuccess = isSuccess else {
                return
            }
            if isSuccess {
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    self.didTapLogout?()
                }
            }
        }
    }
    
    // MARK: - Actions
    var didTapLogout: (() -> Void)?
    
    @IBAction private func logOutPressed(_ sender: UIButton) {
        self.logOutViewModel.doLogOut()
    }
    
    @IBAction private func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
