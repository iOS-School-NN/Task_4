//
//  DSLocation+CoreDataProperties.swift
//  
//
//  Created by Alexander on 24.08.2021.
//
//

import Foundation
import CoreData

extension DSLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DSLocation> {
        return NSFetchRequest<DSLocation>(entityName: "DSLocation")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
}
