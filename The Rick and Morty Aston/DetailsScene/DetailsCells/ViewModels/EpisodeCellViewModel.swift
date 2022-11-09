//
//  EpisodeCellViewModel.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 12.10.2022.
//

import Foundation

protocol CharacterEpisodeCellViewModelProtocol {
    var title: String { get }
    var episodeCode: String { get }
    init(episode: Episode)
}

class CharacterEpisodeCellViewModel: CharacterEpisodeCellViewModelProtocol {
    
    var title: String {
        episode.name
    }
    
    var episodeCode: String {
        episode.episode
    }
    
    private let episode: Episode
    
    required init(episode: Episode) {
        self.episode = episode
    }
    
    
}
