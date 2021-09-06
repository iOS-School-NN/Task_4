//
//  DetailViewController.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

class DetailViewController: UIViewController, MainViewControllerDelegate, DownloadViewControllerDelegate, DetailViewModelDelegate {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var detailCharacterImageView: UIImageView!
    
    @IBOutlet private weak var detailCharacterNameLabel: UILabel!
    @IBOutlet private weak var detailCharacterGenderLabel: UILabel!
    @IBOutlet private weak var detailCharacterStatusLabel: UILabel!
    @IBOutlet private weak var detailCharacterTypeLabel: UILabel!
    
    @IBOutlet private weak var detailLocationTitleLabel: UILabel!
    @IBOutlet private weak var detailCharacterLocationNameLabel: UILabel!
    @IBOutlet private weak var detailCharacterLocationTypeLabel: UILabel!
    
    @IBOutlet private weak var detailEpisodesTitleLabel: UILabel!
    @IBOutlet private weak var detailDescriptionOfEpisodesTextView: UITextView!
    
    private var detailViewModel: DetailViewModel?
    private var characterCard: CharacterCardModel?
    private var characterLocation: CharacterLocationModel?
    private var characterEpisodes: [CharactersEpisodesModel]?
    private var downloadedItem: CharacterObject? = nil
    private var characterId: Int = -1
    private let characterDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if downloadedItem != nil {
            updateAttributesByDownloadedItem()
        } else {
            self.navigationItem.title = "Loading..."
            preLoading()
        }
    }
    
    func initCharacterCard(_ id: Int) {
        self.detailViewModel = DetailViewModel(characterId: id)
        self.detailViewModel?.delegate = self
        self.detailViewModel?.loadDetailInformation()
    }
    
    func updateDownloadedItem(_ item: CharacterObject) {
        self.downloadedItem = item
    }
    
    private func updateAttributesByDownloadedItem() {
        guard let downloadedItem = self.downloadedItem else {
            return
        }
        self.characterId = Int(downloadedItem.id)
        activityIndicator.isHidden = true
        
        self.navigationItem.title = downloadedItem.name
        detailCharacterNameLabel.text = "Name: " + (downloadedItem.name ?? "")
        detailCharacterGenderLabel.text = "Gender: " + (downloadedItem.gender ?? "")
        detailCharacterStatusLabel.text = "Status: " + (downloadedItem.status ?? "")
        detailCharacterTypeLabel.text = "Type: " + (downloadedItem.type ?? "")
        
        detailLocationTitleLabel.text = "Location: "
        detailCharacterLocationNameLabel.text = "Name: " + (downloadedItem.location?.name ?? "")
        detailCharacterLocationTypeLabel.text = "Type: " + (downloadedItem.location?.type ?? "")
        
        detailEpisodesTitleLabel.text = "Episodes: "
        detailDescriptionOfEpisodesTextView.isSelectable = false
        
        guard let characterEpisodes = downloadedItem.episode?.allObjects as? [EpisodeObject] else { return }
        var string = ""
        for i in 0..<characterEpisodes.count {
            string += "• " + (characterEpisodes[i].episode ?? "") + "/"
            string += (characterEpisodes[i].name ?? "") + "/"
            string += (characterEpisodes[i].airDate ?? "") + "\n"
        }

        let attributedString = NSMutableAttributedString(string: string)
        detailDescriptionOfEpisodesTextView.attributedText = attributedString

        updateUIBarItem()
    }
    
    private func preLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        detailCharacterNameLabel.text = ""
        detailCharacterGenderLabel.text = ""
        detailCharacterStatusLabel.text = ""
        detailCharacterTypeLabel.text = ""
        
        detailLocationTitleLabel.text = ""
        detailCharacterLocationNameLabel.text = ""
        detailCharacterLocationTypeLabel.text = ""
        
        detailEpisodesTitleLabel.text = ""
        detailDescriptionOfEpisodesTextView.isSelectable = false
        detailDescriptionOfEpisodesTextView.text = ""
    }
    
    func updateDetailViewBy(characterCard: CharacterCardModel, characterLocation: CharacterLocationModel, characterEpisodes: [CharactersEpisodesModel]) {
        
        self.characterCard = characterCard
        self.characterLocation = characterLocation
        self.characterEpisodes = characterEpisodes
        
        self.characterId = characterCard.id
        detailCharacterImageView.loadImageWithoutCache(by: characterCard.image)
        self.navigationItem.title = characterCard.name
        detailCharacterNameLabel.text = "Name: " + characterCard.name
        detailCharacterGenderLabel.text = "Gender: " + characterCard.gender
        detailCharacterStatusLabel.text = "Status: " + characterCard.status
        detailCharacterTypeLabel.text = "Type: " + characterCard.type
        
        detailLocationTitleLabel.text = "Location: "
        detailCharacterLocationNameLabel.text = "Name: " + characterLocation.name
        detailCharacterLocationTypeLabel.text = "Type: " + characterLocation.type
        
        detailEpisodesTitleLabel.text = "Episodes: "
        detailDescriptionOfEpisodesTextView.isSelectable = false

        var string = ""
        for i in 0..<characterEpisodes.count {
            string += "• " + (characterEpisodes[i].episode + "/" + characterEpisodes[i].name + "/" + characterEpisodes[i].airDate) + "\n"
        }
        
        let attributedString = NSMutableAttributedString(string: string)
        detailDescriptionOfEpisodesTextView.attributedText = attributedString
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        updateUIBarItem()
        
    }
    private func updateUIBarItem() {
        if (CoreDataManager.shared.findCharacterObjectBy(id: (self.characterId))) == nil {
            if self.downloadedItem == nil {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadButtonTapped))
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonTapped))
        }
    }
    
    @objc private func downloadButtonTapped() {
        guard let characterEpisodes = self.characterEpisodes else { return }
        CoreDataManager.shared.downloadObject(character: self.characterCard, location: self.characterLocation, episodes: characterEpisodes)
        updateUIBarItem()
    }
    
    @objc private func removeButtonTapped() {
        CoreDataManager.shared.deleteObjectBy(characterUid: self.characterId)
        updateUIBarItem()
    }

}
