//
//  CharacterLocationModel.swift
//  Task_3
//
//  Created by KirRealDev on 13.07.2021.
//

import Foundation

struct CharacterLocationModel: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}
