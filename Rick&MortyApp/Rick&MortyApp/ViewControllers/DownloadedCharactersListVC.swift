//
//  DownloadedCharactersListVC.swift
//  Rick&MortyApp
//
//  Created by Alexander on 24.08.2021.
//

import UIKit
import CoreData

final class DownloadedCharactersListVC: UIViewController {
    
    lazy var fetchResultsController: NSFetchedResultsController<DSCharacter> = {
        let frc = DataStoreService.fetchResultsController
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        try? fetchResultsController.performFetch()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private func configure() {
        navigationItem.title = "Downloaded characters"
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DownloadedCharactersListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.cellId, for: indexPath)
        guard let characterCell = cell as? CharacterCell else { assertionFailure(); return cell }
        let character = fetchResultsController.object(at: indexPath)
        let name = character.name ?? ""
        let imageUrl = URL(string: character.imageUrl ?? "")
        
        characterCell.fill(name: name, imageUrl: imageUrl)
        return characterCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = fetchResultsController.object(at: indexPath)
        let detailVC = DownloadedCharacterDetailVC(character: character)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let character = fetchResultsController.object(at: indexPath)
            DataStoreService.context.delete(character)
            DataStoreService.saveContext()
        }
    }
}

extension DownloadedCharactersListVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        NotificationCenter.default.post(name: characterDidChangedKey, object: nil)
    }
}
