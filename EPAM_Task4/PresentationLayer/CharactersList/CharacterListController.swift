import UIKit

protocol CharactersListViewProtocol: AnyObject {
    func updateCharacterList()
}

// Вью экрана "Список персонажей"
final class CharactersListViewController: UITableViewController, CharactersListViewProtocol {
    var presenter: CharactersListPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }

    // Обновление коллекции (вызывается из перентера)
    func updateCharacterList() {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.15
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let characterCell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as! CharacterTableViewCell
        characterCell.character = presenter.characters[indexPath.row]

        presenter.fetchImage(urlString: presenter.characters[indexPath.item].imageURL) { data in
            guard let data = data else {
                return
            }
            characterCell.character?.imageData = data
            characterCell.photo.image = UIImage(data: data)
            characterCell.layoutSubviews()
        }
        
        return characterCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.toCharacterDetail(index: indexPath.row)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y

        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            presenter.fetchCharacters()
        }
    }
}
