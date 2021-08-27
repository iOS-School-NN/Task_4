//
//  Models.swift
//  Rick&MortyApp
//
//  Created by Alexander on 14.07.2021.
//

import Foundation

struct PageInfo {
    let next: String?
    let prev: String?
}

struct Character {
    let identifier: Int
    let name: String
    let gender: String
    let status: String
    let species: String
    let imageUrl: String
    let locationUrl: String
    let episodesUrls: [String]
    
    init(identifier: Int,
         name: String,
         gender: String,
         status: String,
         species: String,
         imageUrl: String,
         locationUrl: String,
         episodesUrls: [String]) {
        self.identifier = identifier
        self.name = name
        self.gender = gender
        self.status = status
        self.species = species
        self.imageUrl = imageUrl
        self.locationUrl = locationUrl
        self.episodesUrls = episodesUrls
    }
    
    init(_ character: DSCharacter?) {
        identifier = Int(character?.identifier ?? 0)
        name = character?.name ?? ""
        gender = character?.gender ?? ""
        status = character?.status ?? ""
        species = character?.species ?? ""
        imageUrl = character?.imageUrl ?? ""
        locationUrl = ""
        episodesUrls = []
    }
}

struct Location {
    let name: String
    let type: String
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    init(_ location: DSLocation?) {
        name = location?.name ?? ""
        type = location?.type ?? ""
    }
}

struct Episode {
    let identifier: Int
    let name: String
    let code: String
    let date: String
    
    init(identifier: Int, name: String, code: String, date: String) {
        self.identifier = identifier
        self.name = name
        self.code = code
        self.date = date
    }
    
    init(_ episode: DSEpisode?) {
        identifier = Int(episode?.identifier ?? 0)
        name = episode?.name ?? ""
        code = episode?.code ?? ""
        date = episode?.date ?? ""
    }
}
