//
//  Builder.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 21.09.2022.
//

import UIKit

protocol BuilderProtocol {
    // error - почему только 2 экрана
    static func buildLoginViewController() -> UINavigationController
    static func buildCharactersViewController() -> UINavigationController
    static func buildDetailViewController(viewModel: CharacterDetailViewModelProtocol) -> CharacterDetailView
}

final class Builder: BuilderProtocol {
    static func buildLoginViewController() -> UINavigationController {
        let viewModel = LoginViewModel(dataManager: DataManager.shared)
        let viewController = LoginViewController(loginViewModel: viewModel)
        return UINavigationController(rootViewController: viewController)
    }
    
    static func buildCharactersViewController() -> UINavigationController {
        let viewModel = CharactersViewModel(
            networkManager: NetworkManager.shared,
            dataManager: DataManager.shared
        )
        let viewController = CharactersView(charactersViewModel: viewModel)
        return UINavigationController(rootViewController: viewController)
    }
    
    static func buildDetailViewController(viewModel: CharacterDetailViewModelProtocol) -> CharacterDetailView {
        CharacterDetailView(characterDetailViewModel: viewModel)
    }
}
