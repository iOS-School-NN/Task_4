//
//  CharacterObject+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Grifus on 23.07.2021.
//
//

import Foundation
import CoreData


extension CharacterObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterObject> {
        return NSFetchRequest<CharacterObject>(entityName: "CharacterObject")
    }

    @NSManaged public var gender: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var species: String?
    @NSManaged public var status: String?
    @NSManaged public var episode: NSSet?
    @NSManaged public var location: LocationObject?

}

// MARK: Generated accessors for episode
extension CharacterObject {

    @objc(addEpisodeObject:)
    @NSManaged public func addToEpisode(_ value: EpisodeObject)

    @objc(removeEpisodeObject:)
    @NSManaged public func removeFromEpisode(_ value: EpisodeObject)

    @objc(addEpisode:)
    @NSManaged public func addToEpisode(_ values: NSSet)

    @objc(removeEpisode:)
    @NSManaged public func removeFromEpisode(_ values: NSSet)

}

extension CharacterObject : Identifiable {

}
