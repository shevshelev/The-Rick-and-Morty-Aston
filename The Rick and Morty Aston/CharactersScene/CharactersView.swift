//
//  CharactersView.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 05.10.2022.
//

import UIKit

// error UITableViewController лучше не использовать
final class CharactersView: BaseViewController {
    // MARK: - UI Elements
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .blue
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private lazy var tableView = UITableView()
    // MARK: - Private properties
    private var charactersViewModel: CharactersViewModelProtocol
    private lazy var updateData = { [unowned self] in
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
    // MARK: - Initialisers
    init(charactersViewModel: CharactersViewModelProtocol) {
        self.charactersViewModel = charactersViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view = tableView
        title = "Characters"
        view.backgroundColor = UIColor(
            red: 254/255,
            green: 249/255,
            blue: 140/255,
            alpha: 1
        )
        activityIndicator.startAnimating()
        charactersViewModel.fetchCharacter(completion: updateData)
        view.addSubviews([activityIndicator])
        setupNavigationBar()
        setupTableView()
    }
    override func viewWillLayoutSubviews() {
        activityIndicator.setOnCenterSuperView()
    }
    // MARK: - UIActions Methods
    @objc private func nextButtonTaped() {
        activityIndicator.startAnimating()
        charactersViewModel.nextPage(completion: updateData)
        setupButtons()
    }
    @objc private func prevButtonTaped() {
        activityIndicator.startAnimating()
        charactersViewModel.prevPage(completion: updateData)
        setupButtons()
    }
    @objc private func logOutButtonTaped() {
        charactersViewModel.LogOut()
    }
    // MARK: - Private Methods
    private func setupButtons() {
 
        let nextButton = UIBarButtonItem(
            // почему не сделал пагинацию
            title: "Page\(charactersViewModel.page + 1)",
            style: .plain,
            target: self,
            action: #selector(nextButtonTaped)
        )
        let prevButton = UIBarButtonItem(
            title: "\(charactersViewModel.page - 1) page",
            style: .plain,
            target: self,
            action: #selector(prevButtonTaped)
        )
        let logoutButton = UIBarButtonItem(
            title: "LogOut",
            style: .plain,
            target: self,
            action: #selector(logOutButtonTaped)
        )
        if charactersViewModel.page == 1 {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = prevButton
            navigationItem.leftBarButtonItem?.tag = 0
        }
        if charactersViewModel.isLastPage {
            navigationItem.rightBarButtonItems = [logoutButton]
        } else {
            navigationItem.rightBarButtonItems = [nextButton, logoutButton]
            
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupButtons()
    }
    private func setupTableView() {
        tableView.register(CharacterCellView.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}
// MARK: - UITableViewDataSource
extension CharactersView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        charactersViewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        ) as? CharacterCellView else { return UITableViewCell() }
        cell.characterCellViewModel = charactersViewModel.characterCellViewModel(
            at: indexPath
        )
        return cell
    }
}
// MARK: - UITableViewDelegate
extension CharactersView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = charactersViewModel.characterDetailVC(at: indexPath)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
