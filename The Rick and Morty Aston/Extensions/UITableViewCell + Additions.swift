//
//  UITableViewCell + Additions.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 18.10.2022.
//

import UIKit

extension UITableViewCell {
    func setupLabel(with text: String?, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func setupStatusView(cornerRadius: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = cornerRadius
        return view
    }
}
