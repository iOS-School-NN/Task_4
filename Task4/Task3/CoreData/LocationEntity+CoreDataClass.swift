//
//  LocationEntity+CoreDataClass.swift
//  
//
//  Created by Mary Matichina on 10.08.2021.
//
//

import Foundation
import CoreData

@objc(LocationEntity)
public class LocationEntity: NSManagedObject {
    static func object(model: Location, context: NSManagedObjectContext) -> LocationEntity {
        
        let entityDescription = CoreDataManager.shared.getEntityForName("LocationEntity")
        let object = LocationEntity(entity: entityDescription, insertInto: context)
        
        object.name = model.name
        object.type = model.type
        
        return object
    }
}
