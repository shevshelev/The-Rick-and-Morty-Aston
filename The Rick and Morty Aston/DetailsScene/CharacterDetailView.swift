//
//  CharacterDetailView.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 12.10.2022.
//

import UIKit

final class CharacterDetailView: BaseViewController {
    // MARK: - Private properties
    var characterDetailViewModel: CharacterDetailViewModelProtocol
    private let tableView = UITableView()
    // MARK: - Initialisers
    init(characterDetailViewModel: CharacterDetailViewModelProtocol) {
        self.characterDetailViewModel = characterDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Override Methods
    override func viewDidLoad() {
        title = characterDetailViewModel.name
        view = tableView
        setupTableView()
        setupNavBar()
        super.viewDidLoad()
    }
    // MARK: - UIActions Methods
    @objc private func logOut() {
        characterDetailViewModel.logOut()
    }
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(CharacterImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(CharacterStatusCellView.self, forCellReuseIdentifier: "StatusCell")
        tableView.register(CharacterEpisodeCellView.self, forCellReuseIdentifier: "EpisodeCell")
        tableView.register(LiveStatusCell.self, forCellReuseIdentifier: "LiveStatusCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
    }
    
    private func setupNavBar() {
        setupButtons()
    }
    private func setupButtons() {
        let logoutButton = UIBarButtonItem(
            title: "LogOut",
            style: .plain,
            target: self,
            action: #selector(logOut)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }
}
    // MARK: - Table view data source
extension CharacterDetailView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2:
            return 1
        case 1:
            return 4
        default:
            return characterDetailViewModel.episodes.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ImageCell",
                for: indexPath
            ) as? CharacterImageCell else { return UITableViewCell() }
            cell.characterDetailViewModel = characterDetailViewModel
            return cell
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "LiveStatusCell",
                    for: indexPath
                ) as? LiveStatusCell else { return UITableViewCell() }
                cell.characterStatusCellViewModel = CharacterStatusCellViewModel(
                    characterDetail: characterDetailViewModel,
                    indexPath: indexPath
                )
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "StatusCell",
                    for: indexPath
                ) as? CharacterStatusCellView else { return UITableViewCell() }
                cell.characterStatusCellViewModel = CharacterStatusCellViewModel(
                    characterDetail: characterDetailViewModel,
                    indexPath: indexPath
                )
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TitleCell",
                for: indexPath
            )
            var content = cell.defaultContentConfiguration()
            content.textProperties.font = .boldSystemFont(ofSize: 30)
            content.text = "Episodes:"
            cell.contentConfiguration = content
            cell.backgroundColor = view.backgroundColor
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "EpisodeCell",
                for: indexPath
            ) as? CharacterEpisodeCellView else { return UITableViewCell() }
            characterDetailViewModel.characterEpisodeCellView(
                indexPath: indexPath
            ) { viewModel in
                cell.characterEpisodeCellViewModel = viewModel
            }
            return cell
        }
    }
}

