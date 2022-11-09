//
//  CharacterCellView.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 05.10.2022.
//

import UIKit

final class CharacterCellView: UITableViewCell {
    // MARK: - Public Properties
    var characterCellViewModel: CharacterCellViewModelProtocol! {
        didSet {
            setupUI()
        }
    }
    // MARK: - UI Elements
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        setupLabel(with: nil, font: .boldSystemFont(ofSize: standardFontSize))
    }()
    
    private lazy var statusView: UIView = {
        setupStatusView(cornerRadius: standardFontSize / 2)
    }()
    
    private lazy var statusLabel: UILabel = {
        setupLabel(with: nil, font: .systemFont(ofSize: standardFontSize))
    }()
    
    private lazy var lastLocationLabel: UILabel = {
        setupLabel(with: "Last known location:", font: .systemFont(ofSize: standardFontSize))
    }()
    
    private lazy var locationLabel: UILabel = {
        setupLabel(with: nil, font: .systemFont(ofSize: standardFontSize))
    }()
    // MARK: - Private properties
    private let standardFontSize: CGFloat = 17
    // MARK: - Override Methods
    override func prepareForReuse() {
        characterImageView.image = nil
    }
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = UIColor(
            red: 254/255,
            green: 249/255,
            blue: 140/255,
            alpha: 1
        )
        characterImageView.fetchImage(from: characterCellViewModel.image)
        nameLabel.text = characterCellViewModel.name
        statusLabel.text = characterCellViewModel.status
        setupStatusViewColor(characterCellViewModel.status)
        locationLabel.text = characterCellViewModel.location
        addSubviews([
            characterImageView,
            nameLabel,
            statusView,
            statusLabel,
            lastLocationLabel,
            locationLabel,
        ])
        setupConstraints()
    }
    
    private func setupStatusViewColor(_ status: String) {
        switch status {
        case "Alive":
            statusView.backgroundColor = .systemGreen
        case "Dead":
            statusView.backgroundColor = .systemRed
        default:
            statusView.backgroundColor = .systemGray
        }
    }
        
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 100),
            
            characterImageView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 5
            ),
            characterImageView.centerYAnchor.constraint(
                equalTo: self.centerYAnchor)
            ,
            characterImageView.heightAnchor.constraint(
                equalTo: self.heightAnchor, constant: -10
            ),
            characterImageView.widthAnchor.constraint(
                equalTo: characterImageView.heightAnchor
            ),
            
            nameLabel.topAnchor.constraint(
                equalTo: characterImageView.topAnchor
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: characterImageView.trailingAnchor,
                constant: 5
            ),
            nameLabel.heightAnchor.constraint(equalToConstant: standardFontSize),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: 20)
            ,
            
            statusView.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 5
            ),
            statusView.leadingAnchor.constraint(
                equalTo: characterImageView.trailingAnchor,
                constant: 5
            ),
            statusView.heightAnchor.constraint(
                equalToConstant: standardFontSize
            ),
            statusView.widthAnchor.constraint(equalToConstant: standardFontSize),
            
            statusLabel.centerYAnchor.constraint(
                equalTo: statusView.centerYAnchor
            ),
            statusLabel.leadingAnchor.constraint(
                equalTo: statusView.trailingAnchor, constant: 3
            ),
            statusLabel.heightAnchor.constraint(
                equalToConstant: standardFontSize
            ),
            statusLabel.trailingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor
            ),
            
            lastLocationLabel.topAnchor.constraint(
                equalTo: statusView.bottomAnchor,
                constant: 5
            ),
            lastLocationLabel.leadingAnchor.constraint(
                equalTo: statusView.leadingAnchor
            ),
            lastLocationLabel.heightAnchor.constraint(
                equalToConstant: standardFontSize
            ),
            lastLocationLabel.trailingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor
            ),
            
            locationLabel.topAnchor.constraint(
                equalTo: lastLocationLabel.bottomAnchor,
                constant: 5
            ),
            locationLabel.leadingAnchor.constraint(
                equalTo: lastLocationLabel.leadingAnchor
            ),
            locationLabel.heightAnchor.constraint(
                equalToConstant: standardFontSize
            ),
            lastLocationLabel.trailingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor
            )
        ])
    }
}

