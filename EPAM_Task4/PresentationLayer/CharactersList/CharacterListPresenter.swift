import UIKit

protocol CharactersListPresenterProtocol: AnyObject {
    var characters: [Character] { get }
    func fetchCharacters()
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void)
    func toCharacterDetail(index: Int)
}

// Презентер экрана "Список персонажей"
final class CharactersListPresenter: CharactersListPresenterProtocol {

    private weak var view: CharactersListViewProtocol!
    private let moduleRouter: ModuleRouterProtocol
    private let networkManager: NetworkManagerProtocol

    private var numberOfPages = 39
    private var currentPage = 1
    private var isPaginating = false

    var characters: [Character] = [] {
        didSet {
            view.updateCharacterList()
        }
    }

    init(view: CharactersListViewProtocol, moduleRouter: ModuleRouterProtocol, networkManager: NetworkManagerProtocol) {
        self.view = view
        self.moduleRouter = moduleRouter
        self.networkManager = networkManager
    }

    func fetchCharacters() {
        guard !isPaginating, currentPage <= numberOfPages else {
            return
        }

        isPaginating = true

        if currentPage == 1 {
            let pageURL = "https://rickandmortyapi.com/api/character?page=\(currentPage)"
            networkManager.fetchPage(urlString: pageURL) { [weak self] page in
                self?.numberOfPages = page?.info.pages ?? 34
                self?.characters += page?.results ?? []
                self?.isPaginating = false
                self?.currentPage += 1
            }
        } else {
            for _ in 0...2 {
                let pageURL = "https://rickandmortyapi.com/api/character?page=\(currentPage)"
                networkManager.fetchPage(urlString: pageURL) { [weak self] page in
                    self?.numberOfPages = page?.info.pages ?? 34
                    self?.characters =  ((self?.characters ?? []) + (page?.results ?? [])).sorted{ $0.id < $1.id }
                    self?.isPaginating = false
                }
                print("page \(currentPage) is loading")
                currentPage += 1
            }
        }

    }

    // Получение изображения как Data
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        networkManager.fetchImage(urlString: urlString, completion: completion)
    }

    // Переход к карточке персонажа
    func toCharacterDetail(index: Int) {
        moduleRouter.toCharacterDetail(character: characters[index])
    }
}
