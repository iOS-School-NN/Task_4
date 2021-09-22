//
//  Response.swift
//  Task3
//
//  Created by Mary Matichina on 14.07.2021.
//

import Foundation
import ObjectMapper

struct Response: Mappable {
    
    var info: Info?
    var characters: [Character]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        info <- map["info"]
        characters <- map["results"]
    }
}
