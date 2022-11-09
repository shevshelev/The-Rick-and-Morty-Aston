//
//  CharactersViewModel.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 05.10.2022.
//

import Foundation

protocol CharactersViewModelProtocol {
//    var isFirstPage: Bool { get }
    var isLastPage: Bool { get }
    var page: Int { get set }
    func fetchCharacter(completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func characterDetailVC(at indexPath: IndexPath) -> CharacterDetailView
    func characterCellViewModel(at indexPath: IndexPath) -> CharacterDetailViewModelProtocol
    func LogOut()
    func nextPage(completion: @escaping () -> Void)
    func prevPage(completion: @escaping () -> Void)
}

final class CharactersViewModel: CharactersViewModelProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let dataManager: DataManagerProtocol
    private var pageCount: Int = 0
    private var characters: [CartoonCharacters] = []
    var page: Int = 1
        
    var isLastPage: Bool {
        page == pageCount
    }
    
    init(networkManager: NetworkManagerProtocol, dataManager: DataManagerProtocol) {
        self.networkManager = networkManager
        self.dataManager = dataManager
    }
    
    func fetchCharacter(completion: @escaping () -> Void) {
        Task {
            do {
                guard let charactersAnswer = try await networkManager.sendRequest(
                    for: .character(requestType: .all(page: page))
                ) as? CharacterAnswer else { return }
                self.characters = charactersAnswer.results
                self.pageCount = charactersAnswer.info.pages
                DispatchQueue.main.async {
                    completion()
                }
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    func LogOut() {
        dataManager.logOut()
        AppDelegate.shared.rootVC.switchToLogout()
    }
    
    func nextPage(completion: @escaping () -> Void) {
        if page < pageCount {
            page += 1
            fetchCharacter(completion: completion)
        }
    }
    
    func prevPage(completion: @escaping () -> Void) {
        if page > 1 {
            page -= 1
            fetchCharacter(completion: completion)
        }
    }
    
    func numberOfRows() -> Int {
        characters.count
    }
    
    func characterDetailVC(at indexPath: IndexPath) -> CharacterDetailView {
        Builder.buildDetailViewController(
            viewModel: characterCellViewModel(at: indexPath)
        )
    }
    
    func characterCellViewModel(at indexPath: IndexPath) -> CharacterDetailViewModelProtocol {
        CharacterDetailViewModel(
            character: characters[indexPath.row],
            dataManager: dataManager
        )
    }
}
