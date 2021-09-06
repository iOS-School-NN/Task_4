//
//  LocationObject+CoreDataClass.swift
//  Task_3
//
//  Created by KirRealDev on 06.09.2021.
//
//

import Foundation
import CoreData

@objc(LocationObject)
public class LocationObject: NSManagedObject {
    static func object(character: CharacterObject, data: CharacterLocationModel, in context: NSManagedObjectContext) -> LocationObject? {
        guard let entity = entity(in: context) else {
            return nil
        }
        let object = LocationObject(entity: entity, insertInto: context)
        
        object.character = character
        object.name = data.name
        object.type = data.type
        
        return object
    }
}
