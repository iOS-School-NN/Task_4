//
//  DownloadedCharacterDetailVC.swift
//  Rick&MortyApp
//
//  Created by Alexander on 25.08.2021.
//

import UIKit

final class DownloadedCharacterDetailVC: UIViewController {
    
    init(character: DSCharacter) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configure()
        fill()
    }
    
    private let character: DSCharacter
    private let padding: CGFloat = 8
    private let headerView = CharacterHeaderView()
    private let locationView = CharacterLocationView()
    private let episodesView = CharacterEpisodesView()
    
    private func configureNavigationBar() {
        navigationItem.title = character.name
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        [headerView, locationView, episodesView].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view .addSubview(subview)
        }
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            locationView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding * 2),
            locationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            locationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            episodesView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: padding * 2),
            episodesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            episodesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            episodesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fill() {
        headerView.fill(character: Character(character))
        locationView.fill(Location(character.location))
        if let episodes = character.episodes?.allObjects as? [DSEpisode] {
            episodesView.fill(episodes.map { Episode($0)})
        }
    }
}
