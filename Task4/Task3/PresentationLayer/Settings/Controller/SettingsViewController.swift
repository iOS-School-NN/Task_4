//
//  SettingsViewController.swift
//  Task3
//
//  Created by Mary Matichina on 10.08.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = SettingsViewModel.shared
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var allowSwitch: UISwitch!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allowSwitch.setOn(viewModel.isActiveSwitch, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func switchAction(_ sender: Any) {
        viewModel.isActiveSwitch = allowSwitch.isOn
        if !allowSwitch.isOn {
            viewModel.removeAll()
        }
    }
}
