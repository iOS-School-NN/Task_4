//
//  DataStoreService.swift
//  Rick&MortyApp
//
//  Created by Alexander on 23.08.2021.
//

import Foundation
import CoreData

class DataStoreService {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CharactersListModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static var fetchResultsController: NSFetchedResultsController<DSCharacter> = {
        let fetchRequest: NSFetchRequest<DSCharacter> = DSCharacter.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()
    
    static func fetchCharacterBy(id: Int) -> DSCharacter? {
        let fetchRequest: NSFetchRequest<DSCharacter> = DSCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %ld", id)
        
        guard let characters = try? context.fetch(fetchRequest) else { return nil }
        return characters.first
    }
    
    static func deleteCharacterBy(id: Int) {
        guard let character = fetchCharacterBy(id: id) else { return }
        context.delete(character)
        saveContext()
    }
    
    static func addCharacter(character: Character, location: Location?, episodes: [Episode]?) {
        guard let location = location, let episodes = episodes  else { return }
        
        let dsLocation = DSLocation(location: location)
        let dsEpisodes = episodes.map { DSEpisode(episode: $0) }
        let dsCharacter = DSCharacter(character: character)
        dsCharacter.location = dsLocation
        dsCharacter.episodes = NSSet(array: dsEpisodes)
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
}
