//
//  CharacterTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Grifus on 10.07.2021.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var characterName: UILabel!
    
    var id: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterImage.layer.cornerRadius = characterImage.bounds.width / 2
    }
    
    func setupName(string: String?) {
        characterName.text = string
    }
    
    func setupImage(imageData: Data?) {
        guard let imageData = imageData else {return}
        characterImage.image = UIImage(data: imageData)
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
