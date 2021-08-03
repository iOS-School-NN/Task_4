//
//  EpisodeObject+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Grifus on 22.07.2021.
//
//

import Foundation
import CoreData


extension EpisodeObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeObject> {
        return NSFetchRequest<EpisodeObject>(entityName: "EpisodeObject")
    }

    @NSManaged public var name: String?
    @NSManaged public var air_date: String?
    @NSManaged public var episode: String?
    @NSManaged public var character: CharacterObject?

}

extension EpisodeObject : Identifiable {

}
