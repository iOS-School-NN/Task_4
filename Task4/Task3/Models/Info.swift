//
//  Info.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import Foundation
import  ObjectMapper

struct Info: Mappable {
    
    var pages: Int?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        pages <- map["pages"]
    }
}
