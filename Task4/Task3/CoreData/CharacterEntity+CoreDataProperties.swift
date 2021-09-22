//
//  CharacterEntity+CoreDataProperties.swift
//  
//
//  Created by Mary Matichina on 10.08.2021.
//
//

import Foundation
import CoreData


extension CharacterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var type: String?
    @NSManaged public var status: String?
    @NSManaged public var species: String?
    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var image: String?
    @NSManaged public var episode: NSSet?
    @NSManaged public var location: LocationEntity?
}

// MARK: Generated accessors for episode
extension CharacterEntity {

    @objc(addEpisodeObject:)
    @NSManaged public func addToEpisode(_ value: EpisodeEntity)

    @objc(removeEpisodeObject:)
    @NSManaged public func removeFromEpisode(_ value: EpisodeEntity)

    @objc(addEpisode:)
    @NSManaged public func addToEpisode(_ values: NSSet)

    @objc(removeEpisode:)
    @NSManaged public func removeFromEpisode(_ values: NSSet)

}
