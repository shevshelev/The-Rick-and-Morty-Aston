//
//  StatusCellViewModel.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 12.10.2022.
//

import Foundation

protocol CharacterStatusCellViewModelProtocol {
    var type: CharacterStatusCellViewModel.StatusCellType  { get }
    var value: String { get async }
    init(characterDetail: CharacterDetailViewModelProtocol, indexPath: IndexPath)
}

class CharacterStatusCellViewModel: CharacterStatusCellViewModelProtocol {
    
    var type: StatusCellType {
        switch rowNumber {
        case 0:
            return .liveStatus
        case 1:
            return .speciesAndGender
        case 2:
            return .location
        default:
            return .firstSeen
        }
    }
    
    var value: String {
        get async {
            switch rowNumber {
            case 0:
                return characterDetail.status
            case 1:
                return characterDetail.speciesAndGender
            case 2:
                return characterDetail.location
            default:
                return await characterDetail.firstEpisode
            }
        }
    }
    
    private let rowNumber: Int
    private let characterDetail: CharacterDetailViewModelProtocol
    
    required init(
        characterDetail: CharacterDetailViewModelProtocol,
        indexPath: IndexPath
    ) {
        self.characterDetail = characterDetail
        rowNumber = indexPath.row
    }
    
    enum StatusCellType: String {
        case liveStatus = "Live status"
        case speciesAndGender = "Species and gender"
        case location = "Last know location"
        case firstSeen = "First seen in"
    }
    
}
