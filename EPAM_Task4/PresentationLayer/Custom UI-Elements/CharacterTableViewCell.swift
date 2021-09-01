import UIKit

final class CharacterTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CharacterCell"

    var character: Character? {
        didSet {
            setCharacterInformation()
        }
    }

    // Изображение персонажа
    let photo: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.backgroundColor = .gray
        photo.clipsToBounds = true

        return photo
    }()

    private func photoConstraints() {
        NSLayoutConstraint.activate([
            photo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photo.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            photo.widthAnchor.constraint(equalTo: photo.heightAnchor),
            photo.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIScreen.main.bounds.width * 0.07)
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

    // Индикатор перехода к модулю "Подробнее о персонаже" (стрелочка)
    private let goToIndicator: UIImageView = {
        let goToIndicator = UIImageView(image: UIImage(named: "goToIndicator"))
        goToIndicator.translatesAutoresizingMaskIntoConstraints = false
        goToIndicator.contentMode = .scaleAspectFit

        return goToIndicator
    }()

    private func goToIndicatorConstraints() {
        NSLayoutConstraint.activate([
            goToIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            goToIndicator.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25),
            goToIndicator.widthAnchor.constraint(equalTo: goToIndicator.heightAnchor),
            goToIndicator.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -UIScreen.main.bounds.width * 0.07)
        ])
    }

    // Имя персонажа
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = Color.black

        return nameLabel
    }()

    private func nameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: photo.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: UIScreen.main.bounds.width * 0.05),
            nameLabel.rightAnchor.constraint(equalTo: goToIndicator.leftAnchor, constant: -UIScreen.main.bounds.width * 0.05)
        ])
    }

    // UIStackView для отображения иконок-характеристик персонажа
    private let characteristicsStackView: UIStackView = {
        let characteristicsStackView = UIStackView()
        characteristicsStackView.translatesAutoresizingMaskIntoConstraints = false
        characteristicsStackView.axis = .horizontal
        characteristicsStackView.alignment = .fill

        return characteristicsStackView
    }()

    private func characteristicsStackViewConstraints() {
        NSLayoutConstraint.activate([
            characteristicsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: UIScreen.main.bounds.width * 0.02),
            characteristicsStackView.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: UIScreen.main.bounds.width * 0.05),
            characteristicsStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.16)
        ])
    }

    // Раса персонажа
    private let speciesLabel: UILabel = {
        let speciesLabel = UILabel()
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        speciesLabel.textColor = Color.gray

        return speciesLabel
    }()

    private func speciesLabelConstraints() {
        NSLayoutConstraint.activate([
            speciesLabel.topAnchor.constraint(equalTo: characteristicsStackView.bottomAnchor, constant: UIScreen.main.bounds.width * 0.03),
            speciesLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: UIScreen.main.bounds.width * 0.05),
            speciesLabel.rightAnchor.constraint(equalTo: goToIndicator.leftAnchor, constant: -UIScreen.main.bounds.width * 0.05)
        ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(photo)
        photoConstraints()

        contentView.addSubview(goToIndicator)
        goToIndicatorConstraints()

        contentView.addSubview(nameLabel)
        nameLabelConstraints()

        contentView.addSubview(characteristicsStackView)
        characteristicsStackViewConstraints()

        contentView.addSubview(speciesLabel)
        speciesLabelConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        photoCorners()
        photoShadow()

        nameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: contentView.bounds.height * 0.16)
        speciesLabel.font = UIFont(name: "HelveticaNeue-Bold", size: contentView.bounds.height * 0.13)
        characteristicsStackView.spacing = contentView.bounds.width * 0.010
    }

    // Генерация новой иконки характеристики
    private func newIcon(image: UIImage?) -> UIImageView {
        let icon = UIImageView(image: image)
        icon.contentMode = .scaleAspectFit
        return icon
    }

    // Настройка ячейки под текущуго персонажа
    private func setCharacterInformation() {
        nameLabel.text = character?.name
        speciesLabel.text = "Species: \(character?.species.capitalized ?? "unknown")"
        characteristicsStackView.subviews.forEach { subview in
            characteristicsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        if let status = character?.status, status != .unknown {
            characteristicsStackView.addArrangedSubview(newIcon(image: UIImage(named: "\(status.rawValue.lowercased())Icon")))
        }

        if let gender = character?.gender, gender != .unknown {
            characteristicsStackView.addArrangedSubview(newIcon(image: UIImage(named: "\(character!.gender.rawValue.lowercased())Icon")))
        }
    }
}
