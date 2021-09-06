//
//  CharacterObject+CoreDataClass.swift
//  Task_3
//
//  Created by KirRealDev on 06.09.2021.
//
//

import Foundation
import CoreData

@objc(CharacterObject)
public class CharacterObject: NSManagedObject {
    static func object(data: CharacterCardModel, in context: NSManagedObjectContext) -> CharacterObject? {
        guard let entity = entity(in: context) else {
            return nil
        }
        let object = CharacterObject(entity: entity, insertInto: context)
        
        object.id = Int64(data.id)
        object.name = data.name
        object.status = data.status
        object.species = data.species
        object.gender = data.gender
        object.image = data.image
        
        return object
    }
}
