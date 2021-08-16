//
//  DetailViewController.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

class DetailViewController: UIViewController, MainViewControllerDelegate, DetailViewModelDelegate {
    
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
    
    var detailViewModel: DetailViewModel?
    var characterCardData: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Loading..."
        preLoading()
    }
    
    func initCharacterCard(_ id: Int) {
        self.detailViewModel = DetailViewModel(characterId: id)
        self.detailViewModel?.delegate = self
        self.detailViewModel?.loadDetailInformation()
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
    }
}
