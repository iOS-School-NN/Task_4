//
//  DSEpisode+CoreDataClass.swift
//  
//
//  Created by Alexander on 24.08.2021.
//
//

import Foundation
import CoreData

public class DSEpisode: NSManagedObject {
    convenience init(episode: Episode) {
        self.init(context: DataStoreService.context)
        identifier = Int64(episode.identifier)
        name = episode.name
        code = episode.code
        date = episode.date
    }
}
