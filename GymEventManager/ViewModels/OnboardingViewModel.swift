//
//  OnboardingViewModel.swift
//  GymEventManager
//
//  Created by Deep on 10/01/2024.
//

import Foundation

class OnboardingViewModel {
    
    // MARK: - Properties
    private var currentPage = 1
    private let imageString = "onboarding-image-"
    private var login = false
    private let pageControlImage = "Rectangle 2"
    
    // MARK: - Getters
    func getPageControlImage() -> String {
        return pageControlImage
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func getImageString() -> String {
        return imageString
    }
    
    func isLogin() -> Bool {
        return login
    }
    
    // MARK: - Functionalities
    func swipingRight() {
        if currentPage > 1 {
            currentPage-=1
        }
        login = false
    }
    
    func swipingLeft() {
        if currentPage < 3 {
            currentPage+=1
        }
        login = true
    }
}
