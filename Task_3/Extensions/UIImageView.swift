//
//  UIImageView.swift
//  Task_3
//
//  Created by KirRealDev on 13.07.2021.
//

import UIKit

extension UIImageView {
    func loadImageWithCache(by imageURL: String, onComplete: @escaping (Data, String) -> Void) {
 
        let url = URL(string: imageURL)!
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let imageData = cache.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageData)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                DispatchQueue.main.async {
                    guard let data = data, let response = response else {
                        return
                    }
            
                    let cacheRepsonse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cacheRepsonse, for: request)
                    onComplete(data, imageURL)
                }
            }.resume()
         }
    }
    
    func loadImageWithoutCache(by imageURL: String) {
 
        let url = URL(string: imageURL)!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            DispatchQueue.main.async {
                guard let data = data, let response = response else {
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTPURLResponse: \(httpResponse.statusCode)")
                }
                self.image = UIImage(data: data)
                }
            }.resume()
         }
    }
