//
//  EpisodeEntity+CoreDataClass.swift
//  
//
//  Created by Mary Matichina on 10.08.2021.
//
//

import Foundation
import CoreData

@objc(EpisodeEntity)
public class EpisodeEntity: NSManagedObject {
    static func object(model: Episode, context: NSManagedObjectContext) -> EpisodeEntity {
        
        let entityDescription = CoreDataManager.shared.getEntityForName("EpisodeEntity")
        let object = EpisodeEntity(entity: entityDescription, insertInto: context)
        
        object.name = model.name
        object.date = model.date
        object.code = model.code
        
        return object
    }
}
