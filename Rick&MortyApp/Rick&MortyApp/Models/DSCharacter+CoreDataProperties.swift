//
//  DSCharacter+CoreDataProperties.swift
//  
//
//  Created by Alexander on 24.08.2021.
//
//

import Foundation
import CoreData

extension DSCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DSCharacter> {
        return NSFetchRequest<DSCharacter>(entityName: "DSCharacter")
    }

    @NSManaged public var gender: String?
    @NSManaged public var identifier: Int64
    @NSManaged public var imageUrl: String?
    @NSManaged public var species: String?
    @NSManaged public var status: String?
    @NSManaged public var name: String?
    @NSManaged public var episodes: NSSet?
    @NSManaged public var location: DSLocation?

}

// MARK: Generated accessors for episodes
extension DSCharacter {

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: DSEpisode)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: DSEpisode)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)
}
