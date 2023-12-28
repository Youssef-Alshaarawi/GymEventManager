//
//  ViewController.swift
//  GymEventManager
//
//  Created by Deep on 17/12/2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var pillPageControl: UIPageControl!
    @IBOutlet weak var mainImageView: UIImageView!
    var currentPage = 1
    @IBOutlet weak var getStartedButton: UIButton!
    let imageString = "onboarding-image-"
    var login = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
        navigationItem.setHidesBackButton(true, animated: false)
        pillPageControl.preferredIndicatorImage = UIImage(named: "Rectangle 2")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
    }
    @IBAction func getStartedPressed(_ sender: UIButton) {
        if login {
            skipButtonPressed(sender)
        } else {
            swipingLeft()
        }
    }
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        let loginView = UIStoryboard.init(name: "LogInView", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogInView") as? LoginViewController
        self.navigationController?.pushViewController(loginView!, animated: true)
    }
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        while sender.currentPage+1 > currentPage {
            swipingLeft()
        }
        while sender.currentPage+1 < currentPage {
            swipingRight()
        }
    }
    // MARK: - Swiping gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                swipingRight()
            case UISwipeGestureRecognizer.Direction.left:
                swipingLeft()
            default:
                    break
            }
        }
    }
    func swipingRight() {
        if currentPage > 1 {
            currentPage-=1
        }
        getStartedButton.setTitle("Get Started", for: .normal)
        login = false
        updateUI()
    }
    func swipingLeft() {
        if currentPage < 3 {
            currentPage+=1
        }
        if currentPage == 3 {
            DispatchQueue.main.async {
                self.getStartedButton.setTitle("Login", for: .normal)
                self.getStartedButton.titleLabel?.textAlignment = .center
                self.login = true
            }
        }
        updateUI()
    }
    func updateUI() {
        UIView.transition(with: mainImageView,
                          duration: 0.6,
                          options: .transitionCrossDissolve,
                          animations: { self.mainImageView.image = UIImage(named:
                                        "\(self.imageString)\(self.currentPage).png")},
                          completion: nil)
        pillPageControl.currentPage = currentPage-1
    }
}
