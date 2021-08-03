//
//  TabBarController.swift
//  RickAndMortyApp
//
//  Created by Grifus on 24.07.2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    var firstViewController: UIViewController?
    var secondViewController: UIViewController?
    var thirdViewController: UIViewController?
    
    override func viewDidLoad() {
        firstViewController = viewControllers?.first
        secondViewController = viewControllers?[1]
        thirdViewController = viewControllers?[2]
        firstViewController?.tabBarItem.title = "Characters"
        firstViewController?.tabBarItem.image = .add
        secondViewController?.tabBarItem.title = "Downloaded"
        secondViewController?.tabBarItem.image = .checkmark
        thirdViewController?.tabBarItem.image = .actions
        thirdViewController?.tabBarItem.title = "Settings"
    }
}
