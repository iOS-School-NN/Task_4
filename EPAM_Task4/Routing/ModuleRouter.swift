import UIKit

protocol ModuleRouterProtocol {
    func setup()
    func toCharacterDetail(character: Character)
}

// Класс отвечающий за переход между модулями (вью) в приложении
final class ModuleRouter: ModuleRouterProtocol {
    private let tabBarController: UITabBarController
    private let moduleBuilder: ModuleBuilderProtocol
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    init(tabBarController: UITabBarController, moduleBuilder: ModuleBuilderProtocol) {
        self.tabBarController = tabBarController
        self.moduleBuilder = moduleBuilder
    }

    // Настройка главного экрана (добавление модулей в UITabBarController)
    func setup() {
        let charactersListModule = UINavigationController(rootViewController: moduleBuilder.buildCharactersListModule(moduleRouter: self, networkManager: networkManager))
        let charactersCollectionModule = UINavigationController(rootViewController: moduleBuilder.buildCharactersCollectionModule(moduleRouter: self, networkManager: NetworkManager()))
        let settingsModule = UINavigationController(rootViewController:moduleBuilder.buildSettingsModule(moduleRouter: self))

        tabBarController.setViewControllers([settingsModule, charactersListModule, charactersCollectionModule], animated: false)

    }

    // Презентация модуля "Подробнее о персонаже"
    func toCharacterDetail(character: Character) {
        let characterDetailModule = moduleBuilder.buildCharacterDetailModule(character: character, moduleRouter: self, networkManager: networkManager)

        tabBarController.present(characterDetailModule, animated: true)

    }
}
