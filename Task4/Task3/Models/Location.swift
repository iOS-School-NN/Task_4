//
//  Location.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import Foundation
import ObjectMapper

struct Location: Mappable {
    
    var name: String?
    var type: String?
    var url: String?

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
        url <- map["url"]
    }
}
