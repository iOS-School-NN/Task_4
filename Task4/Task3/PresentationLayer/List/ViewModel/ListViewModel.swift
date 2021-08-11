//
//  ListViewModel.swift
//  Task3
//
//  Created by Mary Matichina on 14.07.2021.
//

import Foundation

final class ListViewModel {
    
    static let shared = ListViewModel()
    
    // MARK: - Properties
    
    private var localCharacters: [Int: [Character]] = [:]
    private var totalPages: Int = 0
    private let group = DispatchGroup()
    var updateHandler: (() -> Void)? = nil
    
    var characters: [Character] {
        get {
            let keys = localCharacters.map({ $0.key }).sorted(by: { $0 < $1 })
            var allCharacters: [Character] = []
            for key in keys {
                allCharacters.append(contentsOf: localCharacters[key] ?? [])
            }
            return allCharacters
        }
    }
    
    // MARK: - Networking
    
    func fetchData() {
        fetchCharacters(page: 1)
    }
    
    private func fetchCharacters(page: Int, _ completion: (() -> Void)? = nil) {
        print("Start task \(page)")
        NetworkingDataManager.getCharacterList(page: page) { [weak self] resp in
            guard let self = self else {
                return
            }
            
            print("Finish task \(page)")
            
            self.totalPages = resp.info?.pages ?? 0
            self.localCharacters[page] = resp.characters
            self.updateHandler?()
            
            if page == 1 {
                self.asyncDownloadItems(total: self.totalPages, countPages: 3) // loading 3 pages
            }
            completion?()
        }
    }
    
    private func asyncDownloadItems(total: Int, countPages: Int) {
        let queue = DispatchQueue.init(label: "ru.matichina.co")
        
        var count = 0
        
        for index in 2...total {
            count += 1
            
            group.enter()
            queue.async {
                self.fetchCharacters(page: index) { () in
                    self.group.leave()
                }
            }
            
            if count == countPages {
                count = 0
                group.wait()
            }
        }
    }
}
