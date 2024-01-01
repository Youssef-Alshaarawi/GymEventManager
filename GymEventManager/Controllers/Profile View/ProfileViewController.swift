//
//  ProfileViewController.swift
//  GymEventManager
//
//  Created by Deep on 28/12/2023.
//

import UIKit
import FittedSheets

class ProfileViewController: UIViewController {
    static var logOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        if ProfileViewController.logOut {
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
        
    }
    
    // MARK: - Buttons Methods
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func accountInfoPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            let accountInfoView = UIStoryboard.init(name: "AccountInfoView", bundle: Bundle.main).instantiateViewController(withIdentifier: "AccountInfoView") as? AccountInfoViewController
            self.navigationController?.pushViewController(accountInfoView!, animated: true)
        }
    }
    @IBAction func changePasswordPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            let changePasswordView = UIStoryboard.init(name: "ChangePasswordView", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordView") as? ChangePasswordViewController
            self.navigationController?.pushViewController(changePasswordView!, animated: true)
        }
    }
    @IBAction func logOutPressed(_ sender: Any) {
        let logoutView = UIStoryboard.init(name: "LogOutSheetView", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogOutSheetViewController") as? LogOutSheetViewController
        logoutView?.didTapLogout = { [weak self] in
            DispatchQueue.main.async {
                let VC1 = (UIStoryboard.init(name: "OnboardingView", bundle: Bundle.main).instantiateViewController(withIdentifier: "onboardingView") as? OnboardingViewController)!
                let navController = UINavigationController(rootViewController: VC1)
                let appDelegate = UIApplication.shared.delegate as? SceneDelegate
                appDelegate!.window?.rootViewController = navController
            }
        }
        let sheetController = SheetViewController(controller: logoutView!, sizes: [ .fixed(240)])
        sheetController.gripSize = CGSize(width: 50, height: 5)
        self.present(sheetController, animated: true, completion: nil)
    }
}
