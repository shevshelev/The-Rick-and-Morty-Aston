//
//  ImageCellView.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 12.10.2022.
//

import UIKit

class CharacterImageCell: UITableViewCell {
    
    var characterDetailViewModel: CharacterDetailViewModelProtocol! {
        didSet {
            characterImageView.fetchImage(from: characterDetailViewModel.image)
            addSubviews([characterImageView])
            setupConstraints()
        }
    }
    lazy private var characterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(
                equalTo: self.topAnchor
            ),
            characterImageView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor
            ),
            characterImageView.widthAnchor.constraint(
                equalTo: self.widthAnchor
            ),
            characterImageView.heightAnchor.constraint(
                equalTo: self.widthAnchor, multiplier: 0.7
            ),
            self.bottomAnchor.constraint(
                equalTo: characterImageView.bottomAnchor
            )
        ])
    }
}
