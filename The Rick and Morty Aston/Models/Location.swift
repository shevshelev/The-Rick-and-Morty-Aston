//
//  Location.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 05.10.2022.
//

import Foundation

struct LocationAnswer: Decodable {
    let info: Info
    let results: [Location]
}

struct Location: Decodable {
    let name: String
}
