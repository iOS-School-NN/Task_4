//
//  DataBaseManager.swift
//  Task3
//
//  Created by Mary Matichina on 10.08.2021.
//

import Foundation
import CoreData

final class DataBaseManager: NSObject {
    
    static let shared = DataBaseManager()
    
    // MARK: - Configure
    
    // MARK: Save a character in CoreData
    
    func save(character: Character?, episodes: [Episode], location: Location?) {
        guard let character = character else { return }
        let characterEntity = CharacterEntity.object(model: character, context: CoreDataManager.shared.persistentContainer.viewContext)
        
        if let location = location {
            _ = LocationEntity.object(model: location, context: CoreDataManager.shared.persistentContainer.viewContext)
        }
        
        for episode in episodes {
            let episodeEntity = EpisodeEntity.object(model: episode, context: CoreDataManager.shared.persistentContainer.viewContext)
            characterEntity.addToEpisode(episodeEntity)
        }
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Remove a character from CoreData
    
    func remove(characterId: Int) {
        let characterFetchRequestController = CoreDataManager.shared.getFetchRequestController(entityName: "CharacterEntity", sortDescriptorKey: "id", filterKey: String(characterId)) as? NSFetchedResultsController<CharacterEntity>
        try? characterFetchRequestController?.performFetch()
        guard let characterEntity = characterFetchRequestController?.fetchedObjects?.first else {
            return
        }
        
        if let location = characterEntity.location {
            CoreDataManager.shared.persistentContainer.viewContext.delete(location)
        }
        
        characterEntity.episode?.forEach({ (episode) in
            CoreDataManager.shared.persistentContainer.viewContext.delete(episode as! NSManagedObject)
        })
        CoreDataManager.shared.persistentContainer.viewContext.delete(characterEntity)
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Check save in CoreData
    
    func checkSave(characterId: String) -> Bool {
        let characterFetchRequestController = CoreDataManager.shared.getFetchRequestController(entityName: "CharacterEntity", sortDescriptorKey: "id", filterKey: characterId)
        try? characterFetchRequestController.performFetch()
        return characterFetchRequestController.sections?[0].numberOfObjects == 1
    }
    
    // MARK: Remove all characters from CoreData
    
    func removeAll() {
        let entities = [CharacterEntity.self, LocationEntity.self, EpisodeEntity.self]
        let names = entities.compactMap({ $0.entity().name })
        
        names.forEach({
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: $0)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            _ = try? CoreDataManager.shared.persistentContainer.viewContext.execute(deleteRequest)
            CoreDataManager.shared.saveContext()
        })
        
        let characterFetchRequestController = CoreDataManager.shared.getFetchRequestController(entityName: "CharacterEntity", sortDescriptorKey: "id", filterKey: nil)
        try? characterFetchRequestController.performFetch()
    }
}
