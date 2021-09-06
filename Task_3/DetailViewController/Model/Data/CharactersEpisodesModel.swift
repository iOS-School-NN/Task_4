//
//  CharactersEpisodesModel.swift
//  Task_3
//
//  Created by KirRealDev on 22.07.2021.
//

import Foundation

// MARK: - CharactersEpisodesModel
struct CharactersEpisodesModel: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
