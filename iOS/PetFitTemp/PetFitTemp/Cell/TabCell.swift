//
//  TabCell.swift
//  petfit
//
//  Created by 서혜림 on 7/31/24.
//

import UIKit

class TabCell: UICollectionViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 16, weight: .medium)
            titleLabel.textColor = isSelected ? .black : .gray
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
