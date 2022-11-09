//
//  UIStackView+Additions.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 21.09.2022.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }
}
