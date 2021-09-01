import Foundation

// Структура содержит информацию о локации мультсериала "Рик и Морти"
struct Location: Codable {
    let url: String
    var id: Int?
    var name: String?
    var type: String?
}
