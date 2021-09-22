//
//  ListViewController.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import UIKit

final class ListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var selectedItem: Character?
    private var viewModel = ListViewModel.shared
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureObserver()
        viewModel.fetchData()
    }
    
    // MARK: - Configure
    
    private func configureTableView() {
        tableView.separatorColor = .clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let controller = segue.destination as? DetailViewController {
                controller.character = selectedItem
                selectedItem = nil
            }
        }
    }
    
    // MARK: - Observer
    
    private func configureObserver() {
        viewModel.updateHandler = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - Extensions

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CharacterTableViewCell.createForTableView(tableView) as! CharacterTableViewCell
        cell.configure(character: viewModel.characters[indexPath.row])
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = viewModel.characters[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
}
