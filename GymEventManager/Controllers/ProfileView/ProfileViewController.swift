//
//  ProfileViewController.swift
//  GymEventManager
//
//  Created by Deep on 28/12/2023.
//

import UIKit
import FittedSheets

class ProfileViewController: UIViewController {
    
    // MARK: - Buttons Methods
    @IBAction private func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func accountInfoPressed(_ sender: UIButton) {
        let accountInfoView = AccountInfoViewController.getViewController(storyBoard: "AccountInfoView", viewController: "AccountInfoView")
        self.navigationController?.pushViewController(accountInfoView, animated: true)
    }
    
    @IBAction private func changePasswordPressed(_ sender: UIButton) {
        let changePasswordView = ChangePasswordViewController.getViewController(storyBoard: "ChangePasswordView", viewController: "ChangePasswordView")
        self.navigationController?.pushViewController(changePasswordView, animated: true)
    }
    
    @IBAction private func logOutPressed(_ sender: Any) {
        let logoutView = LogOutSheetViewController.getViewController(storyBoard: "LogOutSheetView", viewController: "LogOutSheetViewController")
        logoutView.didTapLogout = { [weak self] in
            self?.performLogOut()
        }
        showLogoutSheetView(logoutView)
    }
    
    private func showLogoutSheetView(_ logoutView: LogOutSheetViewController) {
        let sheetController = SheetViewController(controller: logoutView, sizes: [ .fixed(240)])
        sheetController.gripSize = CGSize(width: 50, height: 5)
        self.present(sheetController, animated: true, completion: nil)
    }
    
    private func performLogOut() {
        DispatchQueue.main.async {
            User.shared.accessToken = nil
            let VC1 = OnboardingViewController.getViewController(storyBoard: "OnboardingView", viewController: "onboardingView")
            let navController = UINavigationController(rootViewController: VC1)
            let appDelegate = UIApplication.shared.delegate as? SceneDelegate
            appDelegate!.window?.rootViewController = navController
        }
    }
}
