//
//  LocationObject+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Grifus on 23.07.2021.
//
//

import Foundation
import CoreData


extension LocationObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationObject> {
        return NSFetchRequest<LocationObject>(entityName: "LocationObject")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var character: CharacterObject?

}

extension LocationObject : Identifiable {

}
