//
//  SettingModel.swift
//  RickAndMortyApp
//
//  Created by Grifus on 25.07.2021.
//

import Foundation

protocol SettingModelDelegate: AnyObject {
    func deleteAll()
}

class SettingModel {
    
    static let shared = SettingModel()
    
    let defaults = UserDefaults.standard
    weak var delegate: SettingModelDelegate?
    
    func saveSettings(isSavingOn: Bool) {
        defaults.set(isSavingOn, forKey: "isSavingOn")
    }
    
    func deleteAll() {
        delegate?.deleteAll()
    }
    
    func isSavingOn() -> Bool {
        return defaults.bool(forKey: "isSavingOn")
    }
}
