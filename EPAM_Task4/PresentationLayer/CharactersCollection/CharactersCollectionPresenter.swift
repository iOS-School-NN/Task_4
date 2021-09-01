import Foundation
import CoreData

protocol CharactersCollectionPresenterProtocol: AnyObject {
    var characters: [Character] { get }
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void)
    func toCharacterDetail(index: Int)
    func removeCharacter(id: Int)
    func setupFRControllerDelegate()
}

// Презентер экрана "Коллекция сохраненных персонажей"
final class CharactersCollectionPresenter: NSObject, CharactersCollectionPresenterProtocol {

    private weak var view: CharactersCollectionViewProtocol!
    private let moduleRouter: ModuleRouterProtocol
    private let networkManager: NetworkManagerProtocol

    private let frController: NSFetchedResultsController<CharacterEntity>? = DatabaseManager.shared.getFetchResultsController(entityName: String(describing: CharacterEntity.self), sortDescriptorKey: "id", filterKey: nil) as? NSFetchedResultsController<CharacterEntity>

    var characters: [Character] = [] {
        didSet {
            view.updateCharacterList()
            characters.isEmpty ? view.setPlaceholderVisible(true) : view.setPlaceholderVisible(false)
        }
    }

    init(view: CharactersCollectionViewProtocol, moduleRouter: ModuleRouterProtocol, networkManager: NetworkManagerProtocol) {
        self.view = view
        self.moduleRouter = moduleRouter
        self.networkManager = networkManager

    }

   func setupFRControllerDelegate() {
        frController?.delegate = self
        try? frController?.performFetch()
        characters = frController?.fetchedObjects?.map { characterObject in
                return Character(characterObject: characterObject)
        } ?? []
    }

    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        networkManager.fetchImage(urlString: urlString, completion: completion)
    }

    func toCharacterDetail(index: Int) {
        moduleRouter.toCharacterDetail(character: characters[index])
    }

    func removeCharacter(id: Int) {
        DatabaseManager.shared.removeCharacter(character: characters[id])
    }
}

extension CharactersCollectionPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        characters = frController?.fetchedObjects?.map { characterObject in
                return Character(characterObject: characterObject)
        } ?? []
    }
}
