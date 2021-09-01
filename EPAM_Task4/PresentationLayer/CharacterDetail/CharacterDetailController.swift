import UIKit

protocol CharacterDetailViewProtocol: AnyObject {
    func setLocation(name: String, type: String)
    func setEpisode(episode: String, name: String, airDate: String)
    func setCharacter(imageData: Data, name: String, status: Character.Status, gender: Character.Gender, species: String)
    func presentAlert()
    func isSaved(_ isSaved: Bool)
}

// Вью экрана "Подробнее о персонаже"
final class CharacterDetailViewController: UIViewController, CharacterDetailViewProtocol {
    var presenter: CharacterDetailPresenterProtocol!

    // Имя персонажа
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = Color.black
        nameLabel.text = "Character Name"
        return nameLabel
    }()

    private func nameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.05)
        ])
    }

    // Изображение персонажа
    private let photo: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.backgroundColor = .gray
        photo.clipsToBounds = true

        return photo
    }()

    private func photoConstraints() {
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: view.bounds.height * 0.05),
            photo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            photo.widthAnchor.constraint(equalTo: photo.heightAnchor),
            photo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width * 0.05)
        ])
    }

    private func photoCorners() {
        photo.layer.cornerRadius = photo.bounds.height / 8
        photo.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }

    private func photoShadow() {
        photo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        photo.layer.shadowOpacity = 1
        photo.layer.shadowRadius = 2
        photo.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    // Кнопка добаления в коллецию / удаления из коллекции
    private let actionButton: UIImageView = {
        let actionButton = UIImageView()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.image = UIImage(named: "downloadIcon")
        actionButton.isUserInteractionEnabled = true

        return actionButton
    }()

    private func actionButtonContraints() {
        NSLayoutConstraint.activate([
            actionButton.centerYAnchor.constraint(equalTo: photo.bottomAnchor),
            actionButton.leftAnchor.constraint(equalTo: photo.leftAnchor, constant: view.bounds.width * 0.05),
            actionButton.widthAnchor.constraint(equalTo: photo.widthAnchor, multiplier: 0.3),
            actionButton.heightAnchor.constraint(equalTo: actionButton.widthAnchor)
        ])
    }

    // Стутус персонажа (жив, мертв, неизвестно)
    private let statusTitleLabel: UILabel = {
        let statusTitleLabel = UILabel()
        statusTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusTitleLabel.textColor = Color.black
        statusTitleLabel.text = "Status:"

        return statusTitleLabel
    }()

    private func statusTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            statusTitleLabel.topAnchor.constraint(equalTo: photo.topAnchor),
            statusTitleLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: view.bounds.width * 0.05)
        ])
    }

    private let statusTextLabel: UILabel = {
        let statusTextLabel = UILabel()
        statusTextLabel.translatesAutoresizingMaskIntoConstraints = false
        statusTextLabel.textColor = Color.black
        statusTextLabel.text = "Alive"

        return statusTextLabel
    }()

    private func statusTextLabelConstraints() {
        NSLayoutConstraint.activate([
            statusTextLabel.centerYAnchor.constraint(equalTo: statusTitleLabel.centerYAnchor),
            statusTextLabel.leftAnchor.constraint(equalTo: statusTitleLabel.rightAnchor, constant: view.bounds.width * 0.02)
        ])
    }

    private let statusIcon: UIImageView = {
        let statusIcon = UIImageView()
        statusIcon.contentMode = .scaleAspectFit
        statusIcon.translatesAutoresizingMaskIntoConstraints = false

        return statusIcon
    }()

    private func statusIconConstraints() {
        NSLayoutConstraint.activate([
            statusIcon.centerYAnchor.constraint(equalTo: statusTextLabel.centerYAnchor),
            statusIcon.leftAnchor.constraint(equalTo: statusTextLabel.rightAnchor, constant: view.bounds.width * 0.02),
            statusIcon.heightAnchor.constraint(equalTo: statusTextLabel.heightAnchor, multiplier: 0.7),
            statusIcon.widthAnchor.constraint(equalTo: statusIcon.heightAnchor)
        ])
    }

    // Пол персонажа
    private let genderTitleLabel: UILabel = {
        let genderTitleLabel = UILabel()
        genderTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        genderTitleLabel.textColor = Color.black
        genderTitleLabel.text = "Gender:"

        return genderTitleLabel
    }()

    private func genderTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            genderTitleLabel.topAnchor.constraint(equalTo: statusTitleLabel.bottomAnchor, constant: view.bounds.height * 0.005),
            genderTitleLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: view.bounds.width * 0.05)
        ])
    }

    private let genderTextLabel: UILabel = {
        let genderTextLabel = UILabel()
        genderTextLabel.translatesAutoresizingMaskIntoConstraints = false
        genderTextLabel.textColor = Color.black
        genderTextLabel.text = "Genderless"

        return genderTextLabel
    }()

    private func genderTextLabelConstraints() {
        NSLayoutConstraint.activate([
            genderTextLabel.centerYAnchor.constraint(equalTo: genderTitleLabel.centerYAnchor),
            genderTextLabel.leftAnchor.constraint(equalTo: genderTitleLabel.rightAnchor, constant: view.bounds.width * 0.02)
        ])
    }

    private let genderIcon: UIImageView = {
        let genderIcon = UIImageView()
        genderIcon.contentMode = .scaleAspectFit
        genderIcon.translatesAutoresizingMaskIntoConstraints = false

        return genderIcon
    }()

    private func genderIconConstraints() {
        NSLayoutConstraint.activate([
            genderIcon.centerYAnchor.constraint(equalTo: genderTextLabel.centerYAnchor),
            genderIcon.leftAnchor.constraint(equalTo: genderTextLabel.rightAnchor, constant: view.bounds.width * 0.02),
            genderIcon.heightAnchor.constraint(equalTo: genderTextLabel.heightAnchor, multiplier: 0.7),
            genderIcon.widthAnchor.constraint(equalTo: genderIcon.heightAnchor)
        ])
    }

    // Раса персонажа
    private let speciesTitleLabel: UILabel = {
        let speciesTitleLabel = UILabel()
        speciesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        speciesTitleLabel.textColor = Color.black
        speciesTitleLabel.text = "Species:"

        return speciesTitleLabel
    }()

    private func speciesTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            speciesTitleLabel.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: view.bounds.height * 0.005),
            speciesTitleLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: view.bounds.width * 0.05)
        ])
    }

    private let speciesTextLabel: UILabel = {
        let speciesTextLabel = UILabel()
        speciesTextLabel.translatesAutoresizingMaskIntoConstraints = false
        speciesTextLabel.textColor = Color.black
        speciesTextLabel.text = "Human"

        return speciesTextLabel
    }()

    private func speciesTextLabelConstraints() {
        NSLayoutConstraint.activate([
            speciesTextLabel.centerYAnchor.constraint(equalTo: speciesTitleLabel.centerYAnchor),
            speciesTextLabel.leftAnchor.constraint(equalTo: speciesTitleLabel.rightAnchor, constant: view.bounds.width * 0.02)
        ])
    }

    // Локация персонажа
    private let locationTitleLabel: UILabel = {
        let locationTitleLabel = UILabel()
        locationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTitleLabel.textColor = Color.black
        locationTitleLabel.text = "Location"

        return locationTitleLabel
    }()

    private func locationTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            locationTitleLabel.topAnchor.constraint(equalTo: speciesTitleLabel.bottomAnchor, constant: view.bounds.height * 0.01),
            locationTitleLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: view.bounds.width * 0.05)
        ])
    }

    // Название локации персонажа
    private let locationNameTitleLabel: UILabel = {
        let locationNameTitleLabel = UILabel()
        locationNameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        locationNameTitleLabel.textColor = Color.black
        locationNameTitleLabel.text = "Name:"

        return locationNameTitleLabel
    }()

    private func locationNameTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            locationNameTitleLabel.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: view.bounds.height * 0.005),
            locationNameTitleLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: view.bounds.width * 0.05)
        ])
    }

    private let locationNameTextLabel: UILabel = {
        let locationNameTextLabel = UILabel()
        locationNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        locationNameTextLabel.textColor = Color.black
        locationNameTextLabel.text = "Earth"

        return locationNameTextLabel
    }()

    private func locationNameTextLabelConstraints() {
        NSLayoutConstraint.activate([
            locationNameTextLabel.centerYAnchor.constraint(equalTo: locationNameTitleLabel.centerYAnchor),
            locationNameTextLabel.leftAnchor.constraint(equalTo: locationNameTitleLabel.rightAnchor, constant: view.bounds.width * 0.02),
            locationNameTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width * 0.05)
        ])
    }

    // Тип локации персонажа
    private let locationTypeTitleLabel: UILabel = {
        let locationTypeTitleLabel = UILabel()
        locationTypeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTypeTitleLabel.textColor = Color.black
        locationTypeTitleLabel.text = "Type:"

        return locationTypeTitleLabel
    }()

    private func locationTypeTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            locationTypeTitleLabel.topAnchor.constraint(equalTo: locationNameTitleLabel.bottomAnchor, constant: view.bounds.height * 0.005),
            locationTypeTitleLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: view.bounds.width * 0.05)
        ])
    }

    private let locationTypeTextLabel: UILabel = {
        let locationTypeTextLabel = UILabel()
        locationTypeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTypeTextLabel.textColor = Color.black
        locationTypeTextLabel.text = "Planet"

        return locationTypeTextLabel
    }()

    private func locationTypeTextLabelConstraints() {
        NSLayoutConstraint.activate([
            locationTypeTextLabel.centerYAnchor.constraint(equalTo: locationTypeTitleLabel.centerYAnchor),
            locationTypeTextLabel.leftAnchor.constraint(equalTo: locationTypeTitleLabel.rightAnchor, constant: view.bounds.width * 0.02),

        ])
    }

    // Эпизоды
    private let episodesTitleLabel: UILabel = {
        let episodesTitleLabel = UILabel()
        episodesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesTitleLabel.textColor = Color.black
        episodesTitleLabel.text = "Episodes"

        return episodesTitleLabel
    }()

    private func episodesTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            episodesTitleLabel.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: view.bounds.height * 0.05),
            episodesTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width * 0.1)
        ])
    }

    // Информация об эпизодах
    private let episodesTextView: UITextView = {
        let episodesTextView = UITextView()
        episodesTextView.translatesAutoresizingMaskIntoConstraints = false
        episodesTextView.isEditable = false
        episodesTextView.isSelectable = false
        return episodesTextView
    }()

    private func episodesTextViewConstraints() {
        NSLayoutConstraint.activate([
            episodesTextView.topAnchor.constraint(equalTo: episodesTitleLabel.bottomAnchor, constant: view.bounds.width * 0.05),
            episodesTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            episodesTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            episodesTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.width * 0.1),
        ])
    }

    let alert: UIAlertController = {
        let alert = UIAlertController(title: "Failure!", message: "Saving is disabled in the settings, please enable it", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        return alert
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(nameLabel)
        nameLabelConstraints()

        view.addSubview(photo)
        photoConstraints()

        view.addSubview(actionButton)
        actionButtonContraints()

        view.addSubview(statusTitleLabel)
        statusTitleLabelConstraints()

        view.addSubview(statusTextLabel)
        statusTextLabelConstraints()

        view.addSubview(genderTitleLabel)
        genderTitleLabelConstraints()

        view.addSubview(genderTextLabel)
        genderTextLabelConstraints()

        view.addSubview(speciesTitleLabel)
        speciesTitleLabelConstraints()

        view.addSubview(speciesTextLabel)
        speciesTextLabelConstraints()

        view.addSubview(locationTitleLabel)
        locationTitleLabelConstraints()

        view.addSubview(locationNameTitleLabel)
        locationNameTitleLabelConstraints()

        view.addSubview(locationNameTextLabel)
        locationNameTextLabelConstraints()

        view.addSubview(locationTypeTitleLabel)
        locationTypeTitleLabelConstraints()

        view.addSubview(locationTypeTextLabel)
        locationTypeTextLabelConstraints()

        view.addSubview(episodesTitleLabel)
        episodesTitleLabelConstraints()

        view.addSubview(episodesTextView)
        episodesTextViewConstraints()

        view.addSubview(statusIcon)
        statusIconConstraints()

        view.addSubview(genderIcon)
        genderIconConstraints()

        let actionButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(actionButtonTouched))
        actionButton.addGestureRecognizer(actionButtonTapGesture)
    }

    // Касание кнопки добавления в коллецию / удаления из коллекции
    @objc func actionButtonTouched() {
        presenter.actionWithCharacter()
    }

    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
        photoCorners()
        photoShadow()

        // Устоновка размера шрифта
        nameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height * 0.03)
        statusTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height * 0.02)
        statusTextLabel.font = UIFont(name: "HelveticaNeue", size: view.bounds.height * 0.02)
        genderTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height * 0.02)
        genderTextLabel.font = UIFont(name: "HelveticaNeue", size: view.bounds.height * 0.02)
        speciesTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height * 0.02)
        speciesTextLabel.font = UIFont(name: "HelveticaNeue", size: view.bounds.height * 0.02)
        locationTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height * 0.02)
        locationNameTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height * 0.02)
        locationNameTextLabel.font = UIFont(name: "HelveticaNeue", size: view.bounds.height * 0.02)
        locationTypeTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height * 0.02)
        locationTypeTextLabel.font = UIFont(name: "HelveticaNeue", size: view.bounds.height * 0.02)
        episodesTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height * 0.025)
        episodesTextView.font = UIFont(name: "HelveticaNeue", size: view.bounds.height * 0.02)
    }

    // Установка информации о персонаже (вызывается из презентера)
    func setCharacter(imageData: Data, name: String, status: Character.Status, gender: Character.Gender, species: String) {
        statusIcon.image = UIImage(named: "\(status.rawValue.lowercased())Icon")
        genderIcon.image = UIImage(named: "\(gender.rawValue.lowercased())Icon")
        photo.image = UIImage(data: imageData)
        nameLabel.text = name
        statusTextLabel.text = status.rawValue
        genderTextLabel.text = gender.rawValue
        speciesTextLabel.text = species
    }

    // Установка информации о локации персонажа (вызывается из презентера)
    func setLocation(name: String, type: String) {
        locationNameTextLabel.text = name
        locationTypeTextLabel.text = type
    }

    // Установка информации об одном из эпизодов (вызывается из презентера)
    func setEpisode(episode: String, name: String, airDate: String) {
        episodesTextView.text += "• \(episode)\\ \(name)\\ \(airDate)\n"
    }

    // Установка кнопки добавить / удалить из коллекции (вызывается из презентера)
    func isSaved(_ isSaved: Bool) {
        actionButton.image = isSaved ? UIImage(named: "removeIcon") : UIImage(named: "downloadIcon")
    }

    // Показать Alert (вызывается из презентера)
    func presentAlert() {
        present(alert, animated: true, completion: nil)
    }
}
