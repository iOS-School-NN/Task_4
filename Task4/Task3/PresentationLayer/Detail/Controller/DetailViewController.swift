//
//  DetailViewController.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var viewModelDetail = DetailViewModel()
    private var viewModelSettings = SettingsViewModel.shared
    private var dataBaseManager = DataBaseManager.shared
    var character: Character?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureLoader()
        configureObserver()
        if let id = character?.id {
            viewModelDetail.fetchData(id: id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    // MARK: - Configure
    
    private func configureTableView() {
        tableView.separatorColor = .clear
    }
    
    private func configureNavBar() {
        guard let character = character else {
            return
        }
        title = character.name
        
        if dataBaseManager.checkSave(characterId: "\(character.id ?? 0)") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeAction))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(saveAction))
        }
    }
    
    private func configureLoader() {
        activityIndicator.isHidden = true
        activityIndicator.layer.cornerRadius = 10.0
        activityIndicator.layer.masksToBounds = true
    }
    
    private func showLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoader() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Actions
    
    @objc private func saveAction() {
        if !viewModelSettings.isActiveSwitch {
            showAlertController()
            return
        }
        dataBaseManager.save(character: viewModelDetail.character, episodes: viewModelDetail.episodes, location: viewModelDetail.location)
        configureNavBar()
    }
    
    @objc private func removeAction() {
        guard let characterID = viewModelDetail.character?.id else { return }
        dataBaseManager.remove(characterId: characterID)
        configureNavBar()
    }
    
    private func showAlertController() {
        let menu = UIAlertController(title: nil, message: "For loading this character you need to give a permission in the settings", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        menu.addAction(ok)
        present(menu, animated: true, completion: nil)
    }
    
    // MARK: - Observer
    
    private func configureObserver() {
        showLoader()
        viewModelDetail.updateHandler = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.hideLoader()
            }
        }
    }
}

// MARK: - Extensions

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModelDetail.character != nil ? 1 : 0
        case 1:
            return viewModelDetail.location != nil ? 2 : 0
        case 2:
            return viewModelDetail.episodes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = CharacterCardTableViewCell.createForTableView(tableView) as! CharacterCardTableViewCell
            if let character = viewModelDetail.character {
                cell.configure(character: character)
            }
            return cell
        case 1:
            let location = viewModelDetail.location
            let text = indexPath.row == 0 ? (location?.name ?? "") : (location?.type ?? "")
            return createTableViewCell(title: text)
        case 2:
            return createTableViewCell(title: viewModelDetail.episodes[indexPath.row].episodeString)
        default:
            return UITableViewCell()
        }
    }
}

// MARK: Cell builder

extension DetailViewController {
    func createTableViewCell(title: String) -> UITableViewCell {
        let cell = TitleTableViewCell.createForTableView(tableView) as! TitleTableViewCell
        cell.configure(title: title)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 1:
            return viewModelDetail.location != nil ? "Location" : nil
        case 2:
            return !viewModelDetail.episodes.isEmpty ? "Episode" : nil
        default:
            return nil
        }
    }
}
