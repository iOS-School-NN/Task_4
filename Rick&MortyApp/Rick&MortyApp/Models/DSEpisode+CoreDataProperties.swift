//
//  DSEpisode+CoreDataProperties.swift
//  
//
//  Created by Alexander on 24.08.2021.
//
//

import Foundation
import CoreData

extension DSEpisode {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DSEpisode> {
        return NSFetchRequest<DSEpisode>(entityName: "DSEpisode")
    }

    @NSManaged public var identifier: Int64
    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var date: String?
}
