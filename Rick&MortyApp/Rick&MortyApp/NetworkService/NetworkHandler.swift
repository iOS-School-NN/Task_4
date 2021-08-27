//
//  NetworkHandler.swift
//  Rick&MortyApp
//
//  Created by Alexander on 15.07.2021.
//

import UIKit

class NetworkHandler {
    private let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func getCharacterPages(url: String, pageCount: Int = 1, completion: @escaping ((PageInfo, [Character])?) -> Void) {
        service.getCharacterPages(url: url, pageCount: pageCount, completion: {
            switch $0 {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
    func getLocation(url: String, completion: @escaping (Location?) -> Void) {
        service.getLocation(url: url) {
            switch $0 {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getEpisodes(urls: [String], completion: @escaping ([Episode]?) -> Void) {
        service.getEpisodes(urls: urls) {
            switch $0 {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
