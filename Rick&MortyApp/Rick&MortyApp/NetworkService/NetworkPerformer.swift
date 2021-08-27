//
//  NetworkPerformer.swift
//  Rick&MortyApp
//
//  Created by Alexander on 13.07.2021.
//

import Foundation

enum ErrorMessage: Error {
    case invalidParsing
    case invalidURL
    case invalidResponse
    case invalidData
}

struct NetworkPerformer {
    let session = URLSession.shared
    
    func performRequest(url: String, completion: @escaping (Result<Data, ErrorMessage>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
