//
//  CharacterDetailViewModel.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 05.10.2022.
//

import Foundation

protocol CharacterCellViewModelProtocol: AnyObject {
    var name: String { get }
    var status: String { get }
    var location: String { get }
    var image: String { get }
    init(character: CartoonCharacters, dataManager: DataManagerProtocol)
}

protocol CharacterDetailViewModelProtocol: CharacterCellViewModelProtocol {
    var speciesAndGender: String { get }
    var firstEpisode: String { get async }
    var episodes: [String] { get }
    func logOut()
    func characterEpisodeCellView(indexPath: IndexPath, competion: @escaping(CharacterEpisodeCellViewModelProtocol) -> Void)
    
}

final class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    
    
    var name: String {
        character.name
    }
    
    var status: String {
        character.status
    }
    
    var speciesAndGender: String {
        "\(character.species), \(character.gender)"
    }
    
    var location: String {
        character.location.name
    }
    
    var image: String {
        character.image
    }
    
    var firstEpisode: String {
        get async {
            guard let firstEpisodeNumber = episodes.first else { return "" }
            do {
                guard let episode = try await NetworkManager.shared.sendRequest(
                    for: .episode(requestType: .multiple(numbers: [firstEpisodeNumber]))
                ) as? [Episode] else { return "" }
                return episode.first?.name ?? ""
            } catch {
                print(error.localizedDescription)
                return "Ошибка!"
            }
        }
    }
    
    var episodes: [String] {
            character.episode
    }
    
    private let dataManager: DataManagerProtocol
    private var character: CartoonCharacters
    
    required init(character: CartoonCharacters, dataManager: DataManagerProtocol) {
        self.character = character
        self.dataManager = dataManager
    }
    
    func logOut() {
        dataManager.logOut()
        AppDelegate.shared.rootVC.switchToLogout()
    }

    // error - не выровнял код
    func characterEpisodeCellView(
        indexPath: IndexPath,
        competion: @escaping(CharacterEpisodeCellViewModelProtocol) -> Void
    ) {
        Task {
            guard let episode = try? await NetworkManager.shared.sendRequest(
                for: .episode(requestType: .multiple(numbers: [episodes[indexPath.row]]))
            ) as? [Episode] else { return }
            DispatchQueue.main.async {
                
                competion(CharacterEpisodeCellViewModel(episode: episode[0]))
            }
        }
    }
}
