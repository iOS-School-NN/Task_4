import Foundation
import Combine

enum API {
    
    static func fetchCharacter(characterId: Int) -> AnyPublisher<Character, Error> {
        //        print(characterId)
        let url = URL(string: "https://rickandmortyapi.com/api/character/\(characterId)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            //            .handleEvents(receiveOutput: { print(NSString(data: $0.data, encoding: String.Encoding.utf8.rawValue)!) })
            .tryMap { try JSONDecoder().decode(Character.self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func fetchCharacterLocation(urlString: String) -> AnyPublisher<LocationType, Error> {
        let url = URL(string: urlString)!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            //            .handleEvents(receiveOutput: { print(NSString(data: $0.data, encoding: String.Encoding.utf8.rawValue)!) })
            .tryMap { try JSONDecoder().decode(LocationType.self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    static func fetchCharacterEpisodes(urlString: String) -> AnyPublisher<Episode, Error> {
        let url = URL(string: urlString)!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            //            .handleEvents(receiveOutput: { print(NSString(data: $0.data, encoding: String.Encoding.utf8.rawValue)!) })
            .tryMap { try JSONDecoder().decode(Episode.self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func fetchCharacters(query: String, page: Int) -> AnyPublisher<[Character], Error> {
        //        print(page, pageSize)
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            //            .handleEvents(receiveOutput: { print(NSString(data: $0.data, encoding: String.Encoding.utf8.rawValue)!) })
            .tryMap { try JSONDecoder().decode(CharacterResult<Character>.self, from: $0.data).results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct CharacterResult<T: Codable>: Codable {
    let results: [T]
}

struct Character: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let image: String
    let gender: String
    let status: String
    let species: String
    let location: Location
    let episode: [String]
}

struct Location: Codable, Equatable {
    let name: String
    let url: String
}

struct LocationType: Codable {
    let name: String
    let type: String
}

public struct Episode: Codable, Hashable {
    let url: String
    let name: String
    let air_date: String
    let episode: String
}
