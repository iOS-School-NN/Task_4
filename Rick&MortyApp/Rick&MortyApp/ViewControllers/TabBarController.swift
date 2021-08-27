//
//  TabBarController.swift
//  Rick&MortyApp
//
//  Created by Alexander on 23.08.2021.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private let networkService = NetworkServiceImpl()
    
    private func configure() {
        let charactersListVC = configureCharactersListVC()
        let downloadedListVC = configureDownloadedListVC()
        let settingsVC = configureSettingsVC()
        
        viewControllers = [charactersListVC, downloadedListVC, settingsVC]
    }
    
    private func configureCharactersListVC() -> UIViewController {
        let charactersListVC = CharactersListVC(networkService: networkService)
        let charactersNavigation = UINavigationController(rootViewController: charactersListVC)
        
        charactersNavigation.title = "Characters"
        charactersNavigation.tabBarItem.image = UIImage(systemName: "list.bullet")
        return charactersNavigation
    }
    
    private func configureDownloadedListVC() -> UIViewController {
        let downloadedListVC = DownloadedCharactersListVC()
        let downloadedNavigation = UINavigationController(rootViewController: downloadedListVC)
        
        downloadedNavigation.title = "Downloaded"
        downloadedNavigation.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
        return downloadedNavigation
    }
    
    private func configureSettingsVC() -> UIViewController {
        let settingsVC = SettingsVC()
        let settingsNavigation = UINavigationController(rootViewController: settingsVC)
        
        settingsNavigation.title = "Settings"
        settingsNavigation.tabBarItem.image = UIImage(systemName: "gearshape")
        return settingsNavigation
    }
}
