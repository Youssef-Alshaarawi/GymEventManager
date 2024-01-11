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
    let onboardingViewModel = OnboardingViewModel()
    
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
        pillPageControl.preferredIndicatorImage = UIImage(named: onboardingViewModel.getPageControlImage())
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
        if onboardingViewModel.isLogin() {
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
        if newPage > onboardingViewModel.getCurrentPage() {
            swipingLeft()
        } else if newPage < onboardingViewModel.getCurrentPage() {
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
        onboardingViewModel.swipingRight()
        getStartedButton.setTitle("Get Started", for: .normal)
        updateUI()
    }
    
    private func swipingLeft() {
        onboardingViewModel.swipingLeft()
        if onboardingViewModel.getCurrentPage() == 3 {
            DispatchQueue.main.async {
                self.getStartedButton.setTitle("Login", for: .normal)
                self.getStartedButton.titleLabel?.textAlignment = .center
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
            self.mainImageView.image = UIImage(named: "\(onboardingViewModel.getImageString())\(onboardingViewModel.getCurrentPage()).png")
        },
                          completion: nil)
        pillPageControl.currentPage = onboardingViewModel.getCurrentPage() - 1
    }
}
