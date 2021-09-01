import UIKit

protocol CharactersCollectionViewProtocol: AnyObject {
    func updateCharacterList()
    func setPlaceholderVisible(_ isVisible: Bool)
}

// Вью экрана "Коллекция сохраненных персонажей"
final class CharactersCollectionViewController: UITableViewController, CharactersCollectionViewProtocol {
    var presenter: CharactersCollectionPresenterProtocol!

    // Заглушка "В коллеции нет персонажей"
    let placeholder: UIImageView = {
        let placeholder = UIImageView()
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.image = UIImage(named: "placeholder")
        placeholder.contentMode = .scaleAspectFit
        placeholder.isHidden = true

        return placeholder
    }()

    func placeholderConstraints() {
        NSLayoutConstraint.activate([
            placeholder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholder.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            placeholder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholder.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        presenter.setupFRControllerDelegate()

        view.addSubview(placeholder)
        placeholderConstraints()
    }

    // Обновление списка персонажей
    func updateCharacterList() {
        tableView.reloadData()
    }

    // Показать/скрыть заглушку "В коллеции нет персонажей"
    func setPlaceholderVisible(_ isVisible: Bool) {
        placeholder.isHidden = !isVisible
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            presenter.removeCharacter(id: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)

            tableView.endUpdates()

        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

}
