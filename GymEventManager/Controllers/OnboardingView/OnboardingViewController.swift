//
//  ViewController.swift
//  GymEventManager
//
//  Created by Deep on 17/12/2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet private weak var pillPageControl: UIPageControl!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var getStartedButton: UIButton!
    
    // MARK: - Properties
    var currentPage = 1
    let imageString = "onboarding-image-"
    var login = false
    
    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationController()
        setupSwipingGestures()
        setupPageControl()
    }
    
    private func setupPageControl() {
        pillPageControl.preferredIndicatorImage = UIImage(named: "Rectangle 2")
    }
    
    private func setupSwipingGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction private func getStartedPressed(_ sender: UIButton) {
        if login {
            skipButtonPressed(sender)
        } else {
            swipingLeft()
        }
    }
    
    @IBAction private func skipButtonPressed(_ sender: UIButton) {
        let loginView = LoginViewController.getViewController(storyBoard: "LogInView", viewController: "LogInView")
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    @IBAction private func pageControlChanged(_ sender: UIPageControl) {
        let newPage = sender.currentPage + 1
        if newPage > currentPage {
            swipingLeft()
        } else if newPage < currentPage {
            swipingRight()
        }
    }
    
    // MARK: - Swiping gesture functions
    @objc private func respondToSwipeGesture(gesture: UIGestureRecognizer) {
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
    
    private func swipingRight() {
        if currentPage > 1 {
            currentPage-=1
        }
        getStartedButton.setTitle("Get Started", for: .normal)
        login = false
        updateUI()
    }
    
    private func swipingLeft() {
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
    
    private func updateUI() {
        UIView.transition(with: mainImageView,
                          duration: 0.6,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self =  self else { return }
            self.mainImageView.image = UIImage(named: "\(self.imageString)\(self.currentPage).png")
        },
                          completion: nil)
        pillPageControl.currentPage = currentPage-1
    }
}
