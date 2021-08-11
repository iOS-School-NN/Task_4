//
//  TableViewCell+Extensions.swift
//  Task1
//
//  Created by Mary Matichina on 13.06.2021.
//

import UIKit

extension UITableViewCell {
    
    // MARK: - Configure
    
    static func createForTableView(_ tableView: UITableView) -> UITableViewCell? {
        let className = String(describing:self)
        
        var cell: UITableViewCell? = nil
        
        cell = tableView.dequeueReusableCell(withIdentifier: className)
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as? UITableViewCell
            let cellNib = UINib(nibName: className, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: className)
        }
        return cell
    }
}
