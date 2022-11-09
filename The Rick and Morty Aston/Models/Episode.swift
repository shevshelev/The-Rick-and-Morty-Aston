//
//  Episode.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 05.10.2022.
//

import Foundation

struct EpisodeAnswer: Decodable {
    let info: Info
    let results: [Episode]
}

struct Episode: Decodable {
    let name: String
    let episode: String
}
