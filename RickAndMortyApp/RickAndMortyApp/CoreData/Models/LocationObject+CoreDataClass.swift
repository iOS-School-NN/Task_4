//
//  LocationObject+CoreDataClass.swift
//  RickAndMortyApp
//
//  Created by Grifus on 22.07.2021.
//
//

import Foundation
import CoreData

@objc(LocationObject)
public class LocationObject: NSManagedObject {
    static func object(character: CharacterObject, data: LocationStruct, context: NSManagedObjectContext) -> LocationObject {
        let entityDescription = DatabaseManager.shared.getEntityForName("LocationObject")
        let object = LocationObject(entity: entityDescription, insertInto: context)
        object.name = data.name
        object.type = data.type
        object.character = character
        return object
    }
}
