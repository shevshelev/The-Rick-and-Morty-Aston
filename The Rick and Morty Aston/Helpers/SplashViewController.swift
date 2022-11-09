//
//  SplashViewController.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 12.10.2022.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeServiceCall()
    }
    
    private func makeServiceCall() {
        DispatchQueue.main.async {
            if self.dataManager.isLogIn() {
                AppDelegate.shared.rootVC.switchToCharacterVC()
            } else {
                AppDelegate.shared.rootVC.switchToLogout()
            }
        }
    }
}

