//
//  NetworkService.swift
//  Rick&MortyApp
//
//  Created by Alexander on 13.07.2021.
//

import Foundation

protocol NetworkService: AnyObject {
    func getCharacterPages(url: String, pageCount: Int, completion: @escaping (Result<(PageInfo, [Character]), ErrorMessage>) -> Void)
    func getEpisodes(urls: [String], completion: @escaping (Result<[Episode], ErrorMessage>) -> Void)
    func getLocation(url: String, completion: @escaping (Result<Location, ErrorMessage>) -> Void)
}

class NetworkServiceImpl: NetworkService {
    private let performer = NetworkPerformer()
    
    func getCharactersPage(url: String, completion: @escaping (Result<(PageInfo, [Character]), ErrorMessage>) -> Void) {
        performer.performRequest(url: url) {
            switch $0 {
            case .success(let data):
                do {
                    let parseResult = try CharacterParser.parseCharactersPage(data)
                    completion(.success(parseResult))
                } catch {
                    completion(.failure(.invalidParsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCharacterPages(url: String, pageCount: Int, completion: @escaping (Result<(PageInfo, [Character]), ErrorMessage>) -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .background)
        let currentPage = Int(url.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 1
        var characters = [Character]()
        var pageInfo = PageInfo(next: nil, prev: nil)
        
        (currentPage..<currentPage + pageCount).forEach { page in
            let pageUrl = "https://rickandmortyapi.com/api/character/?page=" + "\(page)"
            group.enter()
            queue.async {
                self.getCharactersPage(url: pageUrl) {
                    switch $0 {
                    case .success(let result):
                        characters.append(contentsOf: result.1)
                        if page == currentPage + pageCount - 1 {
                            pageInfo = result.0
                        }
                        group.leave()
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        group.notify(queue: queue) {
            let sortedCharacters = characters.sorted { $0.identifier < $1.identifier }
            let result = (pageInfo, sortedCharacters)
            completion(.success(result))
        }
    }
    
    func getEpisode(url: String, completion: @escaping (Result<Episode, ErrorMessage>) -> Void) {
        performer.performRequest(url: url) {
            switch $0 {
            case .success(let data):
                do {
                    let parseResult = try CharacterParser.parseEpisode(data)
                    completion(.success(parseResult))
                } catch {
                    completion(.failure(.invalidParsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getEpisodes(urls: [String], completion: @escaping (Result<[Episode], ErrorMessage>) -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .background)
        var episodes = [Episode]()
        
        urls.forEach { url in
            group.enter()
            queue.async {
                self.getEpisode(url: url) {
                    switch $0 {
                    case .success(let episode):
                        episodes.append(episode)
                        group.leave()
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        group.notify(queue: queue) {
            completion(.success(episodes.sorted { $0.identifier < $1.identifier }))
        }
    }
    
    func getLocation(url: String, completion: @escaping (Result<Location, ErrorMessage>) -> Void) {
        performer.performRequest(url: url) {
            switch $0 {
            case .success(let data):
                do {
                    let parseResult = try CharacterParser.parseLocation(data)
                    completion(.success(parseResult))
                } catch {
                    completion(.failure(.invalidParsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
