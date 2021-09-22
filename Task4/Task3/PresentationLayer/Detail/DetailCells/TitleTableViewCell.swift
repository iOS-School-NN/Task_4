//
//  TitleTableViewCell.swift
//  Task3
//
//  Created by Mary Matichina on 20.07.2021.
//

import UIKit

final class TitleTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    // MARK: - Configure
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
