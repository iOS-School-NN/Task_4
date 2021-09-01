import UIKit

protocol SettingsViewProtocol: AnyObject {
    func setSaveEnabled(_ to: Bool)
}

// Вью экрана "Настройки"
final class SettingsViewController: UIViewController, SettingsViewProtocol {
    var presenter: SettingsPresenterProtocol!

    // UIStackView для отцентровки UISwitch и UILabel
    private let settingsStackView: UIStackView = {
        let settingsStackView = UIStackView()
        settingsStackView.translatesAutoresizingMaskIntoConstraints = false
        settingsStackView.axis = .vertical
        settingsStackView.alignment = .center
        settingsStackView.spacing = 10

        return settingsStackView
    }()

    private func settingsStackViewConstraints() {
        NSLayoutConstraint.activate([
            settingsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // UISwitch (взаимодействие с пользователем отлючено)
    private let saveEnabledSwitch: UISwitch = {
        let saveEnabledSwitch = UISwitch()
        saveEnabledSwitch.isUserInteractionEnabled = false

        return saveEnabledSwitch
    }()

    // UIView для корректной работы UISwitch (взаимодействует с пользователем)
    private let saveEnabledActionView: UIView = {
        let saveEnabledActionView = UIView()
        saveEnabledActionView.translatesAutoresizingMaskIntoConstraints = false

        return saveEnabledActionView
    }()

    private func saveEnabledActionViewConstraints() {
        NSLayoutConstraint.activate([
            saveEnabledActionView.topAnchor.constraint(equalTo: saveEnabledSwitch.topAnchor),
            saveEnabledActionView.rightAnchor.constraint(equalTo: saveEnabledSwitch.rightAnchor),
            saveEnabledActionView.bottomAnchor.constraint(equalTo: saveEnabledSwitch.bottomAnchor),
            saveEnabledActionView.leftAnchor.constraint(equalTo: saveEnabledSwitch.leftAnchor)
        ])
    }

    // UILabel к UISwitch
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = Color.gray
        descriptionLabel.text = "Enable saving characters in the collection"

        return descriptionLabel
    }()

    private let alert: UIAlertController = {
        let alert = UIAlertController(title: "Are you sure?", message: "All characters from the collection will be removed", preferredStyle: .alert)

        return alert
    }()

    // Добавление кнопок для UIAlertController
    private func configureAlert() {
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.actionHandler()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(settingsStackView)
        settingsStackViewConstraints()

        settingsStackView.addArrangedSubview(saveEnabledSwitch)

        view.addSubview(saveEnabledActionView)
        saveEnabledActionViewConstraints()

        let saveEnabledActionViewGesture = UITapGestureRecognizer(target: self, action:  #selector (saveEnabledSwitchDidTouched))
        saveEnabledActionView.addGestureRecognizer(saveEnabledActionViewGesture)

        settingsStackView.addArrangedSubview(descriptionLabel)

        descriptionLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height * 0.02)

        configureAlert()
    }

    // Обработка нажатия на кнопку "Yes" в Alert
    private func actionHandler() {
        saveEnabledSwitch.setOn(false, animated: true)
        presenter.setSaveEnabled(false)
    }

    // Обработка изменения значения UISwitch
    @objc private func saveEnabledSwitchDidTouched() {
        guard !saveEnabledSwitch.isOn else {
            present(alert, animated: true)
            return
        }

        presenter.setSaveEnabled(true)
        saveEnabledSwitch.setOn(true, animated: true)
    }

    // Установка текущего значения UISwitch при запуске приложения
    func setSaveEnabled(_ to: Bool) {
        saveEnabledSwitch.isOn = to
    }
}
