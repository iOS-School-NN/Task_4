//
//  CoreDataManager.swift
//  Task3
//
//  Created by Mary Matichina on 10.08.2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Const
    
    static let shared = CoreDataManager()
    
    // MARK: - Configure
    
    func getEntityForName(_ string: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: string, in: persistentContainer.viewContext)!
    }
    
    // MARK: - Core Data stack
    
    func getFetchResultsController(entityName: String, sortDescriptorKey: String, filterKey: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortDescriptorKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let filter = filterKey {
            fetchRequest.predicate = NSPredicate(format: "character.id = %@", filter)
        }
        let fetchedResultsVc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsVc
    }
    
    func getFetchRequestController(entityName: String, sortDescriptorKey: String, filterKey: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortDescriptorKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let filter = filterKey {
            fetchRequest.predicate = NSPredicate(format: "id = %@", filter)
        }
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CharacterDataModel")
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
}
