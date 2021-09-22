//
//  EpisodeEntity+CoreDataProperties.swift
//  
//
//  Created by Mary Matichina on 10.08.2021.
//
//

import Foundation
import CoreData


extension EpisodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeEntity> {
        return NSFetchRequest<EpisodeEntity>(entityName: "EpisodeEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var character: CharacterEntity?

}
