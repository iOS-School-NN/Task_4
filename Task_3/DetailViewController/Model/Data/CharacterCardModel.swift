//
//  CharacterCardModel.swift
//  Task_3
//
//  Created by KirRealDev on 22.07.2021.
//

// MARK: - CharacterCardModel
struct CharacterCardModel: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}
