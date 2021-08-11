//
//  DetailViewModel.swift
//  Task3
//
//  Created by Mary Matichina on 20.07.2021.
//

import Foundation

final class DetailViewModel {
    
    // MARK: - Properties
    
    var character: Character?
    var location: Location?
    var episodes: [Episode] = []
    
    var updateHandler: (() -> Void)? = nil
    var group = DispatchGroup()
    var dispatchQueue = DispatchQueue(label: "ru.matichina.co")
    
    // MARK: - Networking
    
    func fetchData(id: Int) {
        
        getCharacterId(id: id) { [weak self] in
            guard let self = self else {
                return
            }
            
            if let location = self.character?.location {
                self.group.enter()
                self.dispatchQueue.async {
                    self.getLocation(location: location)
                }
            }
            
            self.character?.episode?.forEach({ value in
                self.group.enter()
                self.dispatchQueue.async {
                    self.getEpisode(url: value)
                }
            })
            
            self.group.wait()
            
            self.updateHandler?()
        }
    }
    
    private func getCharacterId(id: Int, _ completion: (() -> Void)? = nil) {
        NetworkingDataManager.getCharacterId(id: id, completion: { [weak self] resp in
            guard let self = self else {
                return
            }
            self.character = resp
            completion?()
        })
    }
    
    private func getLocation(location: Location, _ completion: (() -> Void)? = nil) {
        print("LOCATION START")
        NetworkingDataManager.getLocation(location: location, completion: { [weak self] resp in
            guard let self = self else {
                return
            }
            self.location = resp
            print("LOCATION FINISH")
            self.group.leave()
        })
    }
    
    private func getEpisode(url: String, _ completion: (() -> Void)? = nil) {
        print("EPISODE START")
        NetworkingDataManager.getEpisode(url: url, completion: { [weak self] resp in
            guard let self = self else {
                return
            }
            if let resp = resp {
                self.episodes.append(resp)
            }
            print("EPISODE FINISH")
            self.group.leave()
        })
    }
}
