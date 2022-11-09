//
//  LoginViewModel.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 20.09.2022.
//

import Foundation

protocol LoginViewModelProtocol {
    var title: String { get }
    func checkEmailString(email: String, completion: (Bool) -> Void)
    func singIn(email: String, password: String) -> (validEmail: Bool, validPassword: Bool)
    func singUp(email: String, password: String)
    func logIn()
    func createTestUser() -> (email: String, password: String)
    func changeViewModel(completion: (LoginViewModel.ViewModelType) -> Void)
    func confirmNewPassword(first: String, second: String) -> Bool
}

final class LoginViewModel: LoginViewModelProtocol {
    
    var title: String {
        viewModelType.rawValue
    }
    
    private let dataManager: DataManagerProtocol
    private var viewModelType: ViewModelType = .logIn
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    
    func checkEmailString(email: String, completion: (Bool) -> Void) {
        // error можно проще сделать
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        completion(emailPred.evaluate(with: email))
    }
    
    
    func singUp(email: String, password: String) {
        let user = User(name: email, password: password)
        dataManager.createNewUser(user: user)
    }
    
    func logIn() {
        dataManager.logIn()
        AppDelegate.shared.rootVC.switchToCharacterVC()
    }
    
    func createTestUser() -> (email: String, password: String) {
        let user = User.createTestUser()
        dataManager.createNewUser(user: user)
        return (user.name, user.password)
    }
    
    func singIn(email: String, password: String) -> (validEmail: Bool, validPassword: Bool) {
        // не мог залогинется
        let user = User(name: email, password: password)
        if !checkEmail(user: user) {
            return(false, false)
        } else if !checkPassword(user: user) {
            return (true, false)
        } else {
            return(true, true)
        }
    }
    
    func changeViewModel(completion: (ViewModelType) -> Void) {
        switch viewModelType {
        case .logIn:
            viewModelType = .singUp
        case .singUp:
            viewModelType = .logIn
        }
        completion(viewModelType)
    }
    
    func confirmNewPassword(first: String, second: String) -> Bool {
        first == second
    }
    
    private func checkPassword(user: User) -> Bool {
        return dataManager.checkUser(user: user) == user.password
    }
    
    private func checkEmail(user: User) -> Bool {
        return dataManager.checkUser(user: user) != nil
    }
    
    enum ViewModelType: String {
        case logIn = "LogIn"
        case singUp = "SingUp"
    }
    
}
