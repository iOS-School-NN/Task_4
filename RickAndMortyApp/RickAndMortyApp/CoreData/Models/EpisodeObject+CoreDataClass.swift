//
//  EpisodeObject+CoreDataClass.swift
//  RickAndMortyApp
//
//  Created by Grifus on 22.07.2021.
//
//

import Foundation
import CoreData

@objc(EpisodeObject)
public class EpisodeObject: NSManagedObject {
    static func object(data: Episode, context: NSManagedObjectContext) -> EpisodeObject? {
        let entityDescription = DatabaseManager.shared.getEntityForName("EpisodeObject")
        let object = EpisodeObject(entity: entityDescription, insertInto: context)
        object.air_date = data.air_date
        object.episode = data.episode
        object.name = data.name
//        object.character = characterObject
        return object
    }
}
