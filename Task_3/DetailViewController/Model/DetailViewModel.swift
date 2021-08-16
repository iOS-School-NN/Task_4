//
//  DetailViewModel.swift
//  Task_3
//
//  Created by KirRealDev on 15.07.2021.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func updateDetailViewBy(characterCard: CharacterCardModel, characterLocation: CharacterLocationModel, characterEpisodes: [CharactersEpisodesModel])
}

final class DetailViewModel {
    private var id: Int
    private var characterCard: CharacterCardModel?
    private var characterLocation: CharacterLocationModel?
    private var characterEpisodes = [CharactersEpisodesModel]()
    
    weak var delegate: DetailViewModelDelegate?
    private let dispatchGroup = DispatchGroup()
    private let queue = DispatchQueue.global(qos: .userInitiated)
    
    init(characterId: Int) {
        self.id = characterId
    }
    
    func loadDetailInformation() {
        queue.async {
            self.loadCharacterCard(urlString: NetworkConstants.urlForLoadingListOfCharacters + "/\(self.id)")
        }
    }
    
    func loadCharacterCard(urlString: String) {
        NetworkService.performGetRequestForLoadingCharacterCard(url: urlString, onComplete: { [weak self] (data) in
            let checkedData = data
            self?.characterCard = checkedData
            self?.queue.async(group: self?.dispatchGroup, qos: .userInitiated) {
                self?.loadCharacterLocation(urlString: data.location.url)
            }
            self?.queue.async(group: self?.dispatchGroup, qos: .userInitiated) {
                for url in data.episode {
                    self?.loadCharacterEpisodes(urlString: url)
                }
            }
            
            self?.dispatchGroup.notify(queue: DispatchQueue.main) {
                self?.delegate?.updateDetailViewBy(characterCard: (self?.characterCard)!, characterLocation: (self?.characterLocation)!, characterEpisodes: self!.characterEpisodes)
            }
                
        }) { (error) in
                NSLog(error.localizedDescription)
           }
    }
    
    func loadCharacterLocation(urlString: String) {
        dispatchGroup.enter()
        NetworkService.performGetRequestForLoadingCharacterLocation(url: urlString, onComplete: { [weak self] (data) in
            let checkedData = data
            self?.characterLocation = checkedData
            self?.dispatchGroup.leave()
                
        }) { (error) in
                NSLog(error.localizedDescription)
           }
    }
    
    func loadCharacterEpisodes(urlString: String) {
        dispatchGroup.enter()
        NetworkService.performGetRequestForLoadingCharacterEpisodes(url: urlString, onComplete: { [weak self] (data) in
            let checkedData = data
            self?.characterEpisodes.append(checkedData)
            self?.dispatchGroup.leave()
                
        }) { (error) in
                NSLog(error.localizedDescription)
           }
    }
}
