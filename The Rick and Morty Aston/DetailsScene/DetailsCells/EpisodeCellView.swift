//
//  EpisodeCellView.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 12.10.2022.
//

import UIKit

class CharacterEpisodeCellView: UITableViewCell {
    
    var characterEpisodeCellViewModel: CharacterEpisodeCellViewModelProtocol! {
        didSet {
            setupUI()
        }
    }

    lazy private var titleLabel: UILabel = {
        setupLabel(with: nil, font: .boldSystemFont(ofSize: 27))
    }()
    
    lazy private var codeLabel: UILabel = {
        setupLabel(with: nil, font: .systemFont(ofSize: 20))
    }()
    
    private func setupUI() {
        backgroundColor = UIColor(
                        red: 254/255,
                        green: 249/255,
                        blue: 140/255,
                        alpha: 1
                    )
        titleLabel.text = characterEpisodeCellViewModel.title
        codeLabel.text = characterEpisodeCellViewModel.episodeCode
        addSubviews([titleLabel, codeLabel])
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 20
            ),
            titleLabel.heightAnchor.constraint(equalToConstant: 27),
            titleLabel.trailingAnchor.constraint(
                equalTo: codeLabel.leadingAnchor,
                constant: -8
            ),
            
            codeLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            codeLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -20
            ),
            codeLabel.heightAnchor.constraint(equalToConstant: 20),
            codeLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
