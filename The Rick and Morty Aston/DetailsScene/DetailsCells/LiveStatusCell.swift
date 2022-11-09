//
//  LiveStatusCell.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 16.10.2022.
//

import UIKit

class LiveStatusCell: CharacterStatusCellView {
    lazy private var statusView: UIView = {
            return setupStatusView(cornerRadius: 10)
    }()
    
    private func setupStatusViewColor(statusString: String) {
        // error - почему не через энум
        guard let status = LiveStatus(rawValue: statusString) else { return }
        switch status {
        case .alive:
            statusView.backgroundColor = .systemGreen
        case .dead:
            statusView.backgroundColor = .systemRed
        case .unowned:
            statusView.backgroundColor = .systemGray
        }
    }
    
    override func setupStackView() {
        statusView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        statusView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stackView.spacing = 5
        stackView.addArrangedSubview(statusView)
        Task{
            await setupStatusViewColor(statusString: characterStatusCellViewModel.value)
        }
        super.setupStackView()
    }
    
    enum LiveStatus: String {
        case alive = "Alive"
        case dead = "Dead"
        case unowned = "unknown"
    }
}
