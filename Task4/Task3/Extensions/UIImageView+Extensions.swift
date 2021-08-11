//
//  UIImageView+Extensions.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import Foundation
import UIKit

extension UIImageView {
    
    // MARK: - Configure
    
    func set(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data {
                    self?.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
    }
}
