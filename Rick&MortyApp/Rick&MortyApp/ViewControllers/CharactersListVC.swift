//
//  CharactersListVC.swift
//  Rick&MortyApp
//
//  Created by Alexander on 12.07.2021.
//

import UIKit

final class CharactersListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchData()
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        self.networkHandler = NetworkHandler(service: networkService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let networkService: NetworkService
    private let networkHandler: NetworkHandler
    private var data = [Character]()
    private var isPaginating = false
    private var nextPageUrl = "https://rickandmortyapi.com/api/character/"
    
    private let loaderView = LoaderView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private func configure() {
        navigationItem.title = "Characters list"
        
        view.addSubview(tableView)
        view.addSubview(loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loaderView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        isPaginating = true
        loaderView.isShown = true
        
        networkHandler.getCharacterPages(url: nextPageUrl, pageCount: 3) { [weak self] result in
            guard let self = self else { return }
            guard let characterPage = result else {
                DispatchQueue.main.async {
                    self.loaderView.isShown = false
                }
                self.isPaginating = false
                return
            }
            
            self.data.append(contentsOf: characterPage.1)
            self.nextPageUrl = characterPage.0.next ?? ""
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loaderView.isShown = false
                self.isPaginating = false
            }
        }
    }
}

extension CharactersListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.cellId, for: indexPath)
        guard let characterCell = cell as? CharacterCell else { assertionFailure(); return cell }
        let character = data[indexPath.row]
        
        characterCell.fill(name: character.name, imageUrl: URL(string: character.imageUrl))
        return characterCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterDetailVC = CharacterDetailVC(character: data[indexPath.row], networkService: networkService)
        navigationController?.pushViewController(characterDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > tableView.contentSize.height - scrollView.frame.size.height {
            if isPaginating { return }
            fetchData()
        }
    }
}
