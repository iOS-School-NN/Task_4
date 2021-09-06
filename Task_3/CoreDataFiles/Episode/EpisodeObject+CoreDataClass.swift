//
//  EpisodeObject+CoreDataClass.swift
//  Task_3
//
//  Created by KirRealDev on 06.09.2021.
//
//

import Foundation
import CoreData

@objc(EpisodeObject)
public class EpisodeObject: NSManagedObject {
    static func object(data: CharactersEpisodesModel, in context: NSManagedObjectContext) -> EpisodeObject? {
        guard let entity = entity(in: context) else {
            return nil
        }
        let object = EpisodeObject(entity: entity, insertInto: context)
        
        object.episode = data.episode
        object.name = data.name
        object.airDate = data.airDate
        
        return object
    }
}
