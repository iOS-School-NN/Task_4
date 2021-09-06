//
//  EpisodeObject+CoreDataProperties.swift
//  Task_3
//
//  Created by KirRealDev on 06.09.2021.
//
//

import Foundation
import CoreData


extension EpisodeObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeObject> {
        return NSFetchRequest<EpisodeObject>(entityName: "EpisodeObject")
    }

    @NSManaged public var airDate: String?
    @NSManaged public var episode: String?
    @NSManaged public var name: String?
    @NSManaged public var character: CharacterObject?

}

extension EpisodeObject : Identifiable {

}
