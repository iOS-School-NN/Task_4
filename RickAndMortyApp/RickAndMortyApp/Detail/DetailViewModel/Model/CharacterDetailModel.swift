//
//  CharacterDetailModel.swift
//  RickAndMortyApp
//
//  Created by Grifus on 13.07.2021.
//

import Foundation

struct CharacterDetailModel: Codable {
    let id: Int
    let name, status, species: String
    let gender: String
    let location: Location
    let image: String
    let episode: [String]
    let url: String
}

// MARK: - Location
struct Location: Codable {
    let url: String
}
