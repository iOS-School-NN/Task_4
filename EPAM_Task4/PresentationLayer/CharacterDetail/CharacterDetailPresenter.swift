import Foundation
import CoreData

protocol CharacterDetailPresenterProtocol: AnyObject {
    func actionWithCharacter()
}

// Презентер экрана "Подробнее о персонаже"
final class CharacterDetailPresenter: CharacterDetailPresenterProtocol {

    private weak var view: CharacterDetailViewProtocol!
    private let moduleRouter: ModuleRouterProtocol
    private let networkManager: NetworkManagerProtocol
    private var character: Character

    var isSaved: Bool {
        guard let character = DatabaseManager.shared.getCharacterObject(id: character.id) else {
            return false
        }

        return true
    }

    init(character: Character, view: CharacterDetailViewProtocol, moduleRouter: ModuleRouterProtocol, networkManager: NetworkManagerProtocol) {
        self.character = character
        self.view = view
        self.moduleRouter = moduleRouter
        self.networkManager = networkManager

        view.setCharacter(imageData: character.imageData ?? Data(), name: character.name, status: character.status, gender: character.gender, species: character.species)
        view.isSaved(isSaved)

        // Получение информации о локации
        if character.location.type == nil {
            loadLocation()
        } else {
            view.setLocation(name: character.location.name ?? "unnamed", type: character.location.type ?? "No type")
        }

        // Получение информации об эпизодах
        if character.episodes.isEmpty {
            loadEpisodes()
        } else {
            character.episodes.forEach { episode in
                view.setEpisode(episode: episode.episode, name: episode.name, airDate: episode.airDate)
            }
        }
    }

    // Загрузка информации о локации из сети и её передача во вью
    private func loadLocation() {
        networkManager.fetchLocation(urlString: character.location.url) { [weak self] location in
            self?.character.location.id = location?.id
            self?.character.location.name = location?.name
            self?.character.location.type = location?.type

            self?.view.setLocation(name: self?.character.location.name ?? "unnamed", type: self?.character.location.type ?? "No type")
        }
    }

    // Загрузка информации о всех эпизодах из сети и её передача во вью
    private func loadEpisodes() {
        character.episodesURL.forEach { URL in
            networkManager.fetchEpisode(urlString: URL) { [weak self] episode in
                guard let episode = episode else {
                    return
                }

                self?.character.episodes.append(episode)
                self?.view.setEpisode(episode: episode.episode, name: episode.name, airDate: episode.airDate)
            }
        }
    }

    // Сохранение / удаление персонажа
    func actionWithCharacter() {
        guard UserSettings.saveIsEnabled else {
            view.presentAlert()
            return
        }
        if isSaved {
            DatabaseManager.shared.removeCharacter(character: character)
            view.isSaved(false)
        } else {
            DatabaseManager.shared.saveCharacter(character: character)
            view.isSaved(true)
        }
    }
}
