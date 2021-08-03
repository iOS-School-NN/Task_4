//
//  CharacterObject+CoreDataClass.swift
//  RickAndMortyApp
//
//  Created by Grifus on 22.07.2021.
//
//

import Foundation
import CoreData

@objc(CharacterObject)
public class CharacterObject: NSManagedObject {

    static func object(model: CharacterDetailModel, context: NSManagedObjectContext) -> CharacterObject? {
        let entityDescription = DatabaseManager.shared.getEntityForName("CharacterObject")
        let object = CharacterObject(entity:entityDescription, insertInto: context)
        object.id = Int64(model.id)
        object.name = model.name
        object.status = model.status
        object.species = model.species
        object.gender = model.gender
        object.image = model.image
        
        return object
    }
}
