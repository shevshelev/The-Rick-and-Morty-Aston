//
//  RootViewController.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 12.10.2022.
//

import UIKit

final class RootViewController: UIViewController {
    
    private var current: UIViewController
   
    
    init() {
        self.current = SplashViewController(dataManager: DataManager.shared)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func showLoginViewController() {
        let new = Builder.buildLoginViewController()
        addChild(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = new
        print(#function)
    }
    
    func switchToCharacterVC() {
        let new = Builder.buildCharactersViewController()
        animateFadeTransition(to: new)
    }
    
    func switchToLogout() {
        let new = Builder.buildLoginViewController()
        animateDismissTransition(to: new)
    }
    
    private func animateFadeTransition(to new: UIViewController) {
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionFlipFromTop], animations: {}) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
        }
    }
    
    private func animateDismissTransition(to new: UIViewController) {
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionFlipFromBottom], animations: {}) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
        }
    }
}

