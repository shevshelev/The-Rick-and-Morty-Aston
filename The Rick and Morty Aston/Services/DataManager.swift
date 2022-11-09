//
//  DataManager.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 21.09.2022.
//

import Foundation

protocol DataManagerProtocol {
    func createNewUser(user: User)
    func logIn()
    func logOut()
    func isLogIn() -> Bool
    func checkUser(user: User) -> String?
}

final class DataManager: DataManagerProtocol {
    
    static let shared: DataManagerProtocol = DataManager()
    private let userDefaults = UserDefaults.standard
    private let kLogIn = "isLogIn"
    private init() {}
    
    func createNewUser(user: User) {
        userDefaults.set(user.password, forKey: user.name)
    }
    
    func checkUser(user: User) -> String? {
        userDefaults.string(forKey: user.name)
    }
    
    func logIn() {
        userDefaults.set(true, forKey: kLogIn)
    }
    func logOut() {
        userDefaults.set(false, forKey: kLogIn)
    }
    func isLogIn() -> Bool {
        userDefaults.bool(forKey: kLogIn)
    }
}
