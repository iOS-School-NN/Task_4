//
//  Model.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import Foundation
import ObjectMapper

struct Character: Mappable {
    
    var id: Int?
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var location: Location?
    var image: String?
    var episode: [String]?

    init?(map: Map) {}
    
    init(characterEntity: CharacterEntity) {
        self.id = Int(characterEntity.id)
        self.name = characterEntity.name
        self.status = characterEntity.status
        self.species = characterEntity.species
        self.type = characterEntity.type
        self.gender = characterEntity.gender
        self.image = characterEntity.image
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
        species <- map["species"]
        type <- map["type"]
        gender <- map["gender"]
        location <- map["location"]
        image <- map["image"]
        episode <- map["episode"]
    }
}
