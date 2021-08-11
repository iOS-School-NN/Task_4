//
//  CharacterEntity+CoreDataClass.swift
//  
//
//  Created by Mary Matichina on 10.08.2021.
//
//

import Foundation
import CoreData

@objc(CharacterEntity)
public class CharacterEntity: NSManagedObject {
    static func object(model: Character, context: NSManagedObjectContext) -> CharacterEntity {
        
        let entityDescription = CoreDataManager.shared.getEntityForName("CharacterEntity")
        let object = CharacterEntity(entity: entityDescription, insertInto: context)
        
        object.id = Int64(model.id ?? 0) 
        object.name = model.name
        object.status = model.status
        object.species = model.species
        object.type = model.type
        object.gender = model.gender
        object.image = model.image
        
        return object
    }
}
