//
//  DSLocation+CoreDataClass.swift
//  
//
//  Created by Alexander on 24.08.2021.
//
//

import Foundation
import CoreData

public class DSLocation: NSManagedObject {
    convenience init(location: Location) {
        self.init(context: DataStoreService.context)
        name = location.name
        type = location.type
    }
}
