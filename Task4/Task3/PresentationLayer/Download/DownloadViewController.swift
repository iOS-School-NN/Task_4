//
//  DownloadViewController.swift
//  Task3
//
//  Created by Mary Matichina on 10.08.2021.
//

import UIKit
import CoreData

final class DownloadViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var uniName: String? = nil
    private var fetchResult: NSFetchedResultsController<CharacterEntity>? = nil
    private var selectedIndex: IndexPath?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchResult = configureFetchResultsController()
        fetchResult?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? fetchResult?.performFetch()
        tableView.reloadData()
    }
    
    // MARK: Configure
    
    private func configureFetchResultsController() -> NSFetchedResultsController<CharacterEntity>? {
        CoreDataManager.shared.getFetchResultsController(entityName: String(describing: CharacterEntity.self), sortDescriptorKey: "name", filterKey: uniName) as? NSFetchedResultsController<CharacterEntity>
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue",
           let controller = segue.destination as? DetailViewController,
           let selectedIndex = selectedIndex,
           let characterEntity = fetchResult?.sections?[selectedIndex.section].objects?[selectedIndex.row] as? CharacterEntity {
            
            controller.character = Character(characterEntity: characterEntity)
            self.selectedIndex = nil
        }
    }
}

// MARK: - Extensions

extension DownloadViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResult?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResult?.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CharacterTableViewCell.createForTableView(tableView) as! CharacterTableViewCell
        if let characterEntity = fetchResult?.sections?[indexPath.section].objects?[indexPath.row] as? CharacterEntity {
            cell.configure(character: Character(characterEntity: characterEntity))
        }
        return cell
    }
}

extension DownloadViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
           let object = fetchResult?.object(at: indexPath) {
            CoreDataManager.shared.persistentContainer.viewContext.delete(object)
            CoreDataManager.shared.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
}

extension DownloadViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
