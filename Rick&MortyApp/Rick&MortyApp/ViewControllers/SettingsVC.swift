//
//  SettingsVC.swift
//  Rick&MortyApp
//
//  Created by Alexander on 23.08.2021.
//

import UIKit

final class SettingsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private var isDownloadingAllowed: Bool {
        UserDefaults.standard.object(forKey: isDownloadingAllowedKey) as? Bool ?? true
    }
    
    private let padding: CGFloat = 20
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "Разрешить сохранять персонажей"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(switchDidChanged), for: .valueChanged)
        switchView.setOn(isDownloadingAllowed, animated: false)
        return switchView
    }()
    
    private func configure() {
        title = "Settings"
        view.backgroundColor = .white
        
        [titleLabel, switchView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: switchView.leadingAnchor, constant: -8),
            
            switchView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    @objc private func switchDidChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: isDownloadingAllowedKey)
        } else {
            UserDefaults.standard.set(false, forKey: isDownloadingAllowedKey)
            deleteAllCharactersFromDataStore()
        }
    }
    
    private func deleteAllCharactersFromDataStore() {
        guard let controllers = tabBarController?.viewControllers else { return }
        guard let navigationController =  controllers[1] as? UINavigationController else { return }
        guard let downloadedListVC = navigationController.visibleViewController as? DownloadedCharactersListVC else { return }
        guard let characters = downloadedListVC.fetchResultsController.fetchedObjects else { return }
        
        characters.forEach { DataStoreService.context.delete($0) }
        DataStoreService.saveContext()
    }
}
