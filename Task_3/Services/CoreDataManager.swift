//
//  CoreDataManager.swift
//  Task_3
//
//  Created by KirRealDev on 17.08.2021.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }

    // MARK: - Core Data stack
    
    func getFetchResultsController(entityName: String, sortDescriptorKey: String, filterKey: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let sortDescriptor = NSSortDescriptor(key: sortDescriptorKey, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            if let filter = filterKey {
                fetchRequest.predicate = NSPredicate(format: "id = %@", filter)
            }
            let fetchedResultsVc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

            return fetchedResultsVc
        }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CharacterCoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data methods for change characters
    
    func downloadObject(character: CharacterCardModel?, location: CharacterLocationModel?, episodes: [CharactersEpisodesModel]) {
        let contect = persistentContainer.viewContext
        
        guard let character = character else { return }
        let characterObject = CharacterObject.object(data: character, in: contect)!
        
        guard let location = location else { return }
        let _ = LocationObject.object(character: characterObject, data: location, in: contect)
        
        for episode in episodes {
            let episodeObject = EpisodeObject.object(data: episode, in: contect)
            characterObject.addToEpisode(episodeObject!)
        }
        
        saveContext()
    }
    
    func deleteObjectBy(characterUid: Int) {
        let getCharacterFetchRequestController = getFetchResultsController(entityName: "CharacterObject", sortDescriptorKey: "id", filterKey: String(characterUid)) as? NSFetchedResultsController<CharacterObject>
        
        try? getCharacterFetchRequestController?.performFetch()
        let context = persistentContainer.viewContext
        guard let character = getCharacterFetchRequestController?.fetchedObjects?.first else { return }
        
        guard let location = character.location else { return }
        context.delete(location)
        
        guard let episodes = character.episode else { return }
        for episode in episodes {
            if let episode = episode as? NSManagedObject {
                context.delete(episode)
            }
        }
        
        context.delete(character)
        
        saveContext()
    }
    
    func findCharacterObjectBy(id: Int) -> CharacterObject? {
        let getCharacterFetchRequestController = getFetchResultsController(entityName: "CharacterObject", sortDescriptorKey: "id", filterKey: String(id)) as? NSFetchedResultsController<CharacterObject>
        try? getCharacterFetchRequestController?.performFetch()
        
        return getCharacterFetchRequestController?.fetchedObjects?.first
    }

}
