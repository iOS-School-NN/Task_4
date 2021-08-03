//
//  DetailBusinessModel.swift
//  RickAndMortyApp
//
//  Created by Grifus on 15.07.2021.
//

import Foundation

protocol DetailBusinessModelDelegate: AnyObject {
    func receiveData(characterData: CharacterDetailModel)
    func sendPhoto(photo: Data)
    func sendLocation(location: LocationStruct)
    func sendEpisodes(episode: Episode)
    func allDataIsReady()
}

class DetailBusinessModel {
    weak var delegate: DetailBusinessModelDelegate?
    
    let session = URLSession.shared
    let decoder = JSONDecoder()
    let group = DispatchGroup()
    
    func downloadCharacretDetail(characterIndex: Int) {
        let url = URL(string: "https://rickandmortyapi.com/api/character/\(characterIndex)")
        
        self.session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                let characterData = try! self.decoder.decode(CharacterDetailModel.self, from: data)
                self.delegate?.receiveData(characterData: characterData)
            }
        }.resume()
    }
    
    func downloadByGroups(data: CharacterDetailModel) {
        
        self.downloadPhoto(data: data)
        self.downloadLocation(data: data)
        self.downloadEpisodes(data: data)
        
        group.notify(queue: DispatchQueue.main) {
            self.delegate?.allDataIsReady()
        }
    }
    
    func downloadPhoto(data: CharacterDetailModel) {
        group.enter()
        self.session.dataTask(with: URL(string: data.image)!) { (data, response, error) in
            if let data = data {
                self.delegate?.sendPhoto(photo: data)
            }
            self.group.leave()
        }.resume()
    }
    
    func downloadLocation(data: CharacterDetailModel) {
        if data.location.url == "" { return }
        let url = URL(string: data.location.url)
        
        group.enter()
        self.session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                let locationData = try! self.decoder.decode(LocationStruct.self, from: data)
                self.delegate?.sendLocation(location: locationData)
            }
            self.group.leave()
        }.resume()
    }
    
    func downloadEpisodes(data: CharacterDetailModel) {
        for episode in data.episode {
            let url = URL(string: episode)
            group.enter()
            self.session.dataTask(with: url!) { (data, response, error) in
                if let data = data {
                    let episodeData = try! self.decoder.decode(Episode.self, from: data)
                    self.delegate?.sendEpisodes(episode: episodeData)
                }
                self.group.leave()
            }.resume()
        }
    }
}
