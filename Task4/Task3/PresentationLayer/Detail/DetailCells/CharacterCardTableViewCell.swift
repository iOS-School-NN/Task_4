//
//  CharacterCardTableViewCell.swift
//  Task3
//
//  Created by Mary Matichina on 20.07.2021.
//

import UIKit

final class CharacterCardTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    // MARK: - Configure
    
    func configure(character: Character) {
        nameLabel.text = character.name
        genderLabel.text = character.gender
        statusLabel.text = character.status
        typeLabel.text = character.type
        if let photoUrl = character.image {
            photoView.set(imageURL: photoUrl)
        }
    }
}
