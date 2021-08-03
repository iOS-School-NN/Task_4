//
//  SettingViewController.swift
//  RickAndMortyApp
//
//  Created by Grifus on 25.07.2021.
//

import UIKit


class SettingViewController: UIViewController {
    
    @IBOutlet weak var AllowDownloading: UISwitch!
    var isOn: Bool? {
        didSet {
            if isOn == false {
                SettingModel.shared.deleteAll()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isOn = SettingModel.shared.isSavingOn()
        AllowDownloading.isOn = isOn!
    }
    
    @IBAction func AllowDownloading(_ sender: Any) {
        isOn = AllowDownloading.isOn
        SettingModel.shared.saveSettings(isSavingOn: isOn!)
    }
}
