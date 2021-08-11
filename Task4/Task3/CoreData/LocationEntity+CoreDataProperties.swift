//
//  LocationEntity+CoreDataProperties.swift
//  
//
//  Created by Mary Matichina on 10.08.2021.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var location: CharacterEntity?

}
