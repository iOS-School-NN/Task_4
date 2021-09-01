import Foundation

// Структура содержит полученную информацию о странице
struct Page: Codable {
    let info: PageInfo
    let results: [Character]?
}

struct PageInfo: Codable {
    let next: String?
    let prev: String?
    let pages: Int
}
