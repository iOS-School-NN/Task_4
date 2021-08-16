//
//  MainViewController.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func initCharacterCard(_ id: Int)
}

class MainViewController: UIViewController, MainViewModelDelegate {
    
    @IBOutlet private weak var mainTableView: UITableView!
    
    private let mainTableViewCellIdentifier = "characterCell"
    private let detailViewIdentifier = "detailViewController"
    
    private let heightForRow: CGFloat = 112.0
    private var dataArray = [Result]()
    private let mainViewModel = MainViewModel()
    
    weak var mainViewDelegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "List of Characters"
        mainViewModel.delegate = self
        configureTableView()
        mainViewModel.loadInformation()
    }

    func updateTableViewBy(item: [Result]) {
        self.dataArray += item
        self.mainTableView.reloadData()
    }
    
    private func configureTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil), forCellReuseIdentifier: mainTableViewCellIdentifier)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: mainTableViewCellIdentifier) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
       
        if dataArray.isEmpty {
            return UITableViewCell()
        }
        
        cell.configure(dataArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTableView.deselectRow(at: indexPath, animated: true)
        guard let detailViewController = storyboard?.instantiateViewController(identifier: detailViewIdentifier) as? DetailViewController else {
            return
        }
        mainViewDelegate = detailViewController
        mainViewDelegate?.initCharacterCard(dataArray[indexPath.row].id)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
