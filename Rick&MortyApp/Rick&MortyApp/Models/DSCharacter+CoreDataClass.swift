//
//  DSCharacter+CoreDataClass.swift
//  
//
//  Created by Alexander on 23.08.2021.
//
//

import Foundation
import CoreData

public class DSCharacter: NSManagedObject {
    convenience init(character: Character) {
        self.init(context: DataStoreService.context)
        identifier = Int64(character.identifier)
        name = character.name
        gender = character.gender
        status = character.status
        species = character.species
        imageUrl = character.imageUrl
    }
}
