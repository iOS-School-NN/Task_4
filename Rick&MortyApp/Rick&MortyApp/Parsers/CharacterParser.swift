//
//  CharacterParser.swift
//  Rick&MortyApp
//
//  Created by Alexander on 12.07.2021.
//

import Foundation

struct CharacterParser {
    static func parseCharactersPage(_ data: Data) throws -> (PageInfo, [Character]) {
        let decoder = JSONDecoder()
        do {
            let charactersCodable = try decoder.decode(CharactersResultsCodable.self, from: data)
            
            let pageInfo = PageInfo(next: charactersCodable.info.next, prev: charactersCodable.info.prev)
            let characters = charactersCodable.results.map {
                Character(identifier: $0.id,
                          name: $0.name,
                          gender: $0.gender,
                          status: $0.status,
                          species: $0.species,
                          imageUrl: $0.image,
                          locationUrl: $0.location.url,
                          episodesUrls: $0.episode)
            }
            return (pageInfo, characters)
        } catch {
            print(String(describing: error))
            throw ErrorMessage.invalidParsing
        }
    }
    
    static func parseEpisode(_ data: Data) throws -> Episode {
        let decoder = JSONDecoder()
        do {
            let episodeCodable = try decoder.decode(EpisodeCodable.self, from: data)
            return Episode(identifier: episodeCodable.id,
                           name: episodeCodable.name,
                           code: episodeCodable.episode,
                           date: episodeCodable.date)
        } catch {
            print(error.localizedDescription)
            throw ErrorMessage.invalidParsing
        }
    }
    
    static func parseLocation(_ data: Data) throws -> Location {
        let decoder = JSONDecoder()
        do {
            let locationCodable = try decoder.decode(LocationCodable.self, from: data)
            return Location(name: locationCodable.name, type: locationCodable.type)
        } catch {
            print(error.localizedDescription)
            throw ErrorMessage.invalidParsing
        }
    }
}

private struct InfoCodable: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

private struct CharacterLocationCodable: Codable {
    let name: String
    let url: String
}

private struct CharacterCodable: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let location: CharacterLocationCodable
    let episode: [String]
}

private struct CharactersResultsCodable: Codable {
    let info: InfoCodable
    let results: [CharacterCodable]
}

private struct EpisodeCodable: Codable {
    let id: Int
    let name: String
    let date: String
    let episode: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case date = "air_date"
        case episode
    }
}

private struct LocationCodable: Codable {
    let name: String
    let type: String
}
