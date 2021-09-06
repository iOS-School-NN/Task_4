//
//  DownloadViewController.swift
//  Task_3
//
//  Created by KirRealDev on 17.08.2021.
//

import UIKit
import CoreData

protocol DownloadViewControllerDelegate: AnyObject {
    func updateDownloadedItem(_ item: CharacterObject)
}
class DownloadViewController: UIViewController {

    @IBOutlet private weak var downloadTableView: UITableView!
    
    private var characterfetchResultsController: NSFetchedResultsController<CharacterObject>?
    private var characterUniName: String?
    
    private let downloadTableViewCellIdentifier = "downloadedСharacterCell"
    private let detailViewIdentifier = "detailViewController"
    
    private let characterDataManager = CoreDataManager.shared
    
    weak var downloadViewControllerDelegate: DownloadViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        characterfetchResultsController = configureFetchResultsController()
        characterfetchResultsController?.delegate = self
        
        try? characterfetchResultsController?.performFetch()
        downloadTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("fetchedObjects", characterfetchResultsController?.sections?[0].objects?.count ?? 0)
        downloadTableView.reloadData()
    }
    
    private func configureTableView() {
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
    }
    
    func configureFetchResultsController() -> NSFetchedResultsController<CharacterObject>? {
        CoreDataManager.shared.getFetchResultsController(entityName: String(describing: CharacterObject.self), sortDescriptorKey: "name", filterKey: characterUniName) as? NSFetchedResultsController<CharacterObject>
    }
}

extension DownloadViewController: UITableViewDataSource, UITableViewDelegate {
    func numbersOfSections() -> Int {
        return characterfetchResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterfetchResultsController?.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = downloadTableView.dequeueReusableCell(withIdentifier: downloadTableViewCellIdentifier) else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = characterfetchResultsController?.object(at: indexPath).name
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
           let object = characterfetchResultsController?.object(at: indexPath) {
            CoreDataManager.shared.persistentContainer.viewContext.delete(object)
            CoreDataManager.shared.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        downloadTableView.deselectRow(at: indexPath, animated: true)
        guard let item = characterfetchResultsController?.object(at: indexPath) else { return }
        
        guard let detailViewController = storyboard?.instantiateViewController(identifier: detailViewIdentifier) as? DetailViewController else {
            return
        }
        downloadViewControllerDelegate = detailViewController
        downloadViewControllerDelegate?.updateDownloadedItem(item)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension DownloadViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        downloadTableView.reloadData()
    }
}
