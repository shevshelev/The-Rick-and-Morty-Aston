//
//  StatusCellView.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 12.10.2022.
//

import UIKit

class CharacterStatusCellView: UITableViewCell {

    var characterStatusCellViewModel: CharacterStatusCellViewModelProtocol! {
        didSet {
            setupUI()
        }
    }
    
    lazy private var titleLabel: UILabel = {
        setupLabel(
            with: characterStatusCellViewModel.type.rawValue,
            font: .systemFont(ofSize: 10)
        )
    }()
    
    lazy private var valueLabel: UILabel = {
        setupLabel(with: nil, font: .systemFont(ofSize: 17))
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        return stackView
    }()
        
    private func setupUI() {
            self.addSubviews([self.titleLabel, self.stackView])
        backgroundColor = UIColor(
                        red: 254/255,
                        green: 249/255,
                        blue: 140/255,
                        alpha: 1
                    )
        setupStackView()
        setupConstraints()
    }
    
    func setupStackView() {
        Task {
            valueLabel.text = await characterStatusCellViewModel.value
        }
        stackView.addArrangedSubview(valueLabel)
    }
    
    private func setupConstraints() {
        // error у меня здесь крашнулось
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 5
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 20
            ),
            titleLabel.heightAnchor.constraint(equalToConstant: 17),
            titleLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -20
            ),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 20
            ),
            stackView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -20
            ),
            stackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

