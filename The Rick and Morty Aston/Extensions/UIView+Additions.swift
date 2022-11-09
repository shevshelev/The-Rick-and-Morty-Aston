//
//  UIView+Additions.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 21.09.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setOnCenterSuperView(
        xOffset: CGFloat? = 0,
        yOffset: CGFloat? = 0
    ) {
        guard let view = superview else { return }
        if let xOffset = xOffset {
            centerXAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: xOffset
            ).isActive = true
        }
        if let yOffset = yOffset {
            centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: yOffset
            ).isActive = true
        }
    }
    
    func setConstraintsToSuperView(
        top: CGFloat? = nil,
        left: CGFloat? = nil,
        right: CGFloat? = nil,
        bottom: CGFloat? = nil
    ) {
        guard let view = superview else { return }
        if let top = top {
            topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: top
            ).isActive = true
        }
        if let left = left {
            leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: left
            ).isActive = true
        }
        if let right = right {
            trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: right)
            .isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: bottom
            ).isActive = true
        }
    }
    
    func setConstraintsToOtherView(
        otherView: UIView,
        above: CGFloat? = nil,
        below: CGFloat? = nil,
        left: CGFloat? = nil,
        right: CGFloat? = nil
    ) {
        if let above = above {
            bottomAnchor.constraint(
                equalTo: otherView.topAnchor,
                constant: above
            ).isActive = true
        }
        if let below = below {
            topAnchor.constraint(
                equalTo: otherView.bottomAnchor,
                constant: below
            ).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(
                equalTo: otherView.leftAnchor,
                constant: left
            ).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(
                equalTo: otherView.rightAnchor,
                constant: right
            ).isActive = true
        }
    }
}

