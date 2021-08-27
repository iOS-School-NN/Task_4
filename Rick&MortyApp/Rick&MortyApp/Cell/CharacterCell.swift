//
//  CharacterCell.swift
//  Rick&MortyApp
//
//  Created by Alexander on 14.07.2021.
//

import UIKit

final class CharacterCell: UITableViewCell {
    static let cellId = "CharacterCellId"
    static let cellHeight: CGFloat = 76
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(name: String, imageUrl: URL?) {
        characterImageView.loadImage(from: imageUrl)
        nameLabel.text = name
    }
    
    private let padding: CGFloat = 8
    
    private let characterImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private func configure() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            characterImageView.widthAnchor.constraint(equalTo: characterImageView.heightAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
}
