import CoreData

// Модель содержит информацию о персонаже вселенной мультсериала "Рик и Морти"
class Character: Codable {

    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown = "unknown"
    }

    enum Status: String, Codable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }

    let id: Int
    let name: String
    let status: Status
    let species: String
    let gender: Gender
    let imageURL: String
    var imageData: Data?
    let episodesURL: [String]
    var episodes = [Episode]()
    var location: Location
    let isSaved = false

    // Инициализация объекта персонажа из NSManagedObject
    init(characterObject: CharacterEntity) {
        self.id = Int(characterObject.id)
        self.name = characterObject.name ?? ""
        self.status = Character.Status(rawValue: characterObject.status?.capitalized ?? "") ?? .unknown
        self.species = characterObject.species ?? ""
        self.gender =  Character.Gender(rawValue: characterObject.gender?.capitalized ?? "") ?? .unknown
        self.imageURL = characterObject.imageURL ?? ""
        self.episodes = characterObject.episodes?.allObjects.map { episodeObject in
            return Episode(episodeObject: episodeObject as? EpisodeEntity ?? EpisodeEntity())
        } ?? []
        self.location = Location(locationObject: characterObject.location ?? LocationEntity())
        self.episodesURL = []
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case gender
        case imageURL = "image"
        case imageData
        case episodesURL = "episode"
        case location
    }
}
