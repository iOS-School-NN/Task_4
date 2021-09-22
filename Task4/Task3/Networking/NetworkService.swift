//
//  NetworkService.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import Foundation

class NetworkingService {
    
    static let shared = NetworkingService()
    
    // MARK: - Configure
    
    func getData(url: URL, _ completion: ((Any) -> ())? = nil) {
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let queue = DispatchQueue(label: "ru.matichina.co")
                queue.async {
                    completion?(json)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
