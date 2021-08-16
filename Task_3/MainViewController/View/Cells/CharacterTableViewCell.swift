//
//  CharacterTableViewCell.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var characterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        characterImageView.contentMode = .scaleAspectFill
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        characterImageView.layer.cornerRadius = characterImageView.frame.width / 2 
    }
    
    func configure(_ item: Result) {
        characterNameLabel.text = item.name
        characterImageView.loadImageWithCache(by: item.image, onComplete: { [weak self] (data, url) in
            if(item.image == url) {
                self?.characterImageView.image = UIImage(data: data)
            }
        })
    }
    
}
