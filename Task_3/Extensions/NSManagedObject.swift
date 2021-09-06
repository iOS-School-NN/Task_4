//
//  NSManagedObject.swift
//  Task_3
//
//  Created by KirRealDev on 18.08.2021.
//

import Foundation
import CoreData

extension NSManagedObject {
    static func entity(in context: NSManagedObjectContext) -> NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: String(describing: Self.self), in: context)
    }
}
