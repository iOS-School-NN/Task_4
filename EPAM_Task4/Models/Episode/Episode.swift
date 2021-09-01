import Foundation

// Структура содержит информацию об эпизоде мультсериала "Рик и Морти"
struct Episode: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
    }
}
