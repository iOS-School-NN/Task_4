//
//  SettingsViewModel.swift
//  Task3
//
//  Created by Mary Matichina on 11.08.2021.
//

import Foundation

final class SettingsViewModel {
    
    static let shared = SettingsViewModel()
    
    // MARK: - Properties
    
    private var dataBaseManager = DataBaseManager.shared
    
    var isActiveSwitch: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isActiveSwitch")
        }
        get {
            return UserDefaults.standard.bool(forKey: "isActiveSwitch")
        }
    }
    
    // MARK: - Configure
    
    func removeAll() {
        dataBaseManager.removeAll()
    }
}
