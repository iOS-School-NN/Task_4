import UIKit

protocol ModuleBuilderProtocol {
    func buildCharactersListModule( moduleRouter: ModuleRouterProtocol, networkManager: NetworkManagerProtocol) -> UIViewController
    func buildCharactersCollectionModule(moduleRouter: ModuleRouterProtocol, networkManager: NetworkManagerProtocol) -> UIViewController
    func buildCharacterDetailModule(character: Character, moduleRouter: ModuleRouterProtocol, networkManager: NetworkManagerProtocol) -> UIViewController
    func buildSettingsModule(moduleRouter: ModuleRouterProtocol) -> UIViewController
}

// Класс ModuleBuilder отвечает за сборку MVP-модулей
class ModuleBuilder: ModuleBuilderProtocol {

    // Сборка и настройка "Список персонажей"
    func buildCharactersListModule(moduleRouter: ModuleRouterProtocol, networkManager: NetworkManagerProtocol) -> UIViewController {
        let view = CharactersListViewController()
        view.tabBarItem.image = UIImage(named: "charactersList")
        view.tabBarItem.title = "Characters"
        view.title = "Character List"

        view.presenter = CharactersListPresenter(view: view, moduleRouter: moduleRouter, networkManager: networkManager)

        return view
    }

    // Сборка и настройка модуля "Коллекция сохраненных персонажей"
    func buildCharactersCollectionModule(moduleRouter: ModuleRouterProtocol, networkManager: NetworkManagerProtocol) -> UIViewController {
        let view = CharactersCollectionViewController()
        view.tabBarItem.image = UIImage(named: "charactersCollection")
        view.tabBarItem.title = "Collection"
        view.title = "Your Collection"

        view.presenter = CharactersCollectionPresenter(view: view, moduleRouter: moduleRouter, networkManager: networkManager)

        return view
    }

    // Сборка и настройка "Подробнее о персонаже"
    func buildCharacterDetailModule(character: Character, moduleRouter: ModuleRouterProtocol, networkManager: NetworkManagerProtocol) -> UIViewController {
        let view = CharacterDetailViewController()

        view.presenter = CharacterDetailPresenter(character: character, view: view, moduleRouter: moduleRouter, networkManager: networkManager)

        return view
    }

    // Сборка и настройка "Настройки"
    func buildSettingsModule(moduleRouter: ModuleRouterProtocol) -> UIViewController {
        let view = SettingsViewController()
        view.tabBarItem.image = UIImage(named: "settings")
        view.tabBarItem.title = "Settings"
        view.title = "Settings"

        view.presenter = SettingsPresenter(view: view, moduleRouter: moduleRouter)

        return view
    }
}
