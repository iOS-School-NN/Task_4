import UIKit

protocol SettingsPresenterProtocol: AnyObject {
    func setSaveEnabled(_ to: Bool)
}

// Презентер экрана "Настройки"
final class SettingsPresenter: SettingsPresenterProtocol {

    private weak var view: SettingsViewProtocol!
    private let moduleRouter: ModuleRouterProtocol

    init(view: SettingsViewProtocol, moduleRouter: ModuleRouterProtocol) {
        self.view = view
        self.moduleRouter = moduleRouter
        view.setSaveEnabled(UserSettings.saveIsEnabled)
    }

    func setSaveEnabled(_ to: Bool) {
        UserSettings.saveIsEnabled = to

        if !to {
            DatabaseManager.shared.clearDatabase()
        }
    }
}
