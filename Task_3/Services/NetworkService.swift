//
//  NetworkService.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

private enum ServerError: Error {
    
    case noDataProvided
    case failedToDecode
}

struct NetworkConstants {
    static let urlForLoadingListOfCharacters = "https://rickandmortyapi.com/api/character"
}

struct NetworkService {
    
    static func makeGetRequest(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let request = URLRequest(url: url)
        
        return request
    }

    static func performGetRequestForLoadingPages(url: String, pageId: Int, onComplete: @escaping (CharactersPageModel, Int) -> Void, onError: @escaping (Error, Int) -> Void) {
        
        guard let request = makeGetRequest(urlString: url) else {
            return
        }
        print(request)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error, pageId)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTPURLResponse: \(httpResponse.statusCode)")
            }
            guard let  data = data else {
                onError(ServerError.noDataProvided, pageId)
                return
            }
            guard let info = try? JSONDecoder().decode(CharactersPageModel.self, from: data) else {
                NSLog("Could not decode")
                onError(ServerError.failedToDecode, pageId)
                return
            }
            
            DispatchQueue.main.async {
                onComplete(info, pageId)
            }
                
        }
        
        task.resume()
    }
    
    static func performGetRequestForLoadingCharacterCard(url: String, onComplete: @escaping (CharacterCardModel) -> Void, onError: @escaping (Error) -> Void) {
        
        guard let request = makeGetRequest(urlString: url) else {
            return
        }
        print(request)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTPURLResponse: \(httpResponse.statusCode)")
            }
            guard let  data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let info = try? JSONDecoder().decode(CharacterCardModel.self, from: data) else {
                NSLog("Could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            
            DispatchQueue.main.async {
                onComplete(info)
            }
                
        }
        
        task.resume()
    }
    
    static func performGetRequestForLoadingCharacterLocation(url: String, onComplete: @escaping (CharacterLocationModel) -> Void, onError: @escaping (Error) -> Void) {
        
        guard let request = makeGetRequest(urlString: url) else {
            return
        }
        print(request)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTPURLResponse: \(httpResponse.statusCode)")
            }
            guard let  data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let info = try? JSONDecoder().decode(CharacterLocationModel.self, from: data) else {
                NSLog("Could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            
            DispatchQueue.main.async {
                onComplete(info)
            }
                
        }
        
        task.resume()
    }
    
    static func performGetRequestForLoadingCharacterEpisodes(url: String, onComplete: @escaping (CharactersEpisodesModel) -> Void, onError: @escaping (Error) -> Void) {
        
        guard let request = makeGetRequest(urlString: url) else {
            return
        }
        print(request)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTPURLResponse: \(httpResponse.statusCode)")
            }
            guard let  data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let info = try? JSONDecoder().decode(CharactersEpisodesModel.self, from: data) else {
                NSLog("Could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            
            DispatchQueue.main.async {
                onComplete(info)
            }
                
        }
        
        task.resume()
    }
}
