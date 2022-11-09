//
//  User.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 20.09.2022.
//

import Foundation

struct User {
    let name: String
    let password: String
    
    static func createTestUser() -> User {
        User(name: "Test@User.com", password: "TestPassword")
    }
}
