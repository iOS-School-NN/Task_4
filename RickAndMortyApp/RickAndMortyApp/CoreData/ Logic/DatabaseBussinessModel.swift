//
//  DatabaseLogic.swift
//  RickAndMortyApp
//
//  Created by Grifus on 24.07.2021.
//

import Foundation
import CoreData
import UIKit

protocol DatabaseBussinessModelTableDelegate: AnyObject {
    func reloadTable()
}

protocol DatabaseBussinessModelDetailDelegate: AnyObject {
    func download()
    func showAlert()
}

class DatabaseBussinessModel: NSObject {
    weak var delegateForTable: DatabaseBussinessModelTableDelegate?
    weak var delegateForDetail: DatabaseBussinessModelDetailDelegate?
    
    let characterFetchRequestController: NSFetchedResultsController<CharacterObject>? = {
        return DatabaseManager.shared.getFetchResultController(entityName: "CharacterObject", sortDescriptorKey: "id", filterKey: nil) as? NSFetchedResultsController<CharacterObject>
    }()
    
    var episodeFetchRequestController: NSFetchedResultsController<EpisodeObject>?
    var locationFetchRequestController: NSFetchedResultsController<LocationObject>?
    
    func isInCoreData(characterFilterId: String) -> Bool {
        let isCharacterFetchRequestController = DatabaseManager.shared.getFetchRequestControllerObject(entityName: "CharacterObject", sortDescriptorKey: "id", filterKey: characterFilterId)
        try? isCharacterFetchRequestController.performFetch()
        return isCharacterFetchRequestController.sections?[0].numberOfObjects == 1
    }
    
    func configureEpisodeFetchRequestController(filterId: Int) -> NSFetchedResultsController<EpisodeObject>? {
        let filter = String(filterId)
        return DatabaseManager.shared.getFetchResultController(entityName: "EpisodeObject", sortDescriptorKey: "episode", filterKey: filter) as? NSFetchedResultsController<EpisodeObject>
    }
    
    func configureLocationFetchRequestController(filterId: Int) -> NSFetchedResultsController<LocationObject>? {
        let filter = String(filterId)
        return DatabaseManager.shared.getFetchResultController(entityName: "LocationObject", sortDescriptorKey: "name", filterKey: filter) as? NSFetchedResultsController<LocationObject>
    }
    
    func numbersOfSections() -> Int {
        return characterFetchRequestController?.sections?.count ?? 0
    }
    
    func numberOfRows(section: Int) -> Int {
        return characterFetchRequestController?.sections?[section].objects?.count ?? 0
    }
    
    func setupNameForCell(indexPath: IndexPath) -> String? {
        let currentObject = characterFetchRequestController?.object(at: indexPath)
        return currentObject?.name
    }
    
    func setupIdForCell(indexPath: IndexPath) -> Int? {
        let currentObject = characterFetchRequestController?.object(at: indexPath)
        return Int(currentObject?.id ?? 0)
    }
    
    func deleteObject(indexPath: IndexPath) {
        if let object = characterFetchRequestController?.object(at: indexPath) {
            deleteCharacterObject(object: object)
        }
    }
    
    func deleteObject(id: Int) {
        let characterFetchRequestControllerObject: NSFetchedResultsController<CharacterObject>? = {
            DatabaseManager.shared.getFetchRequestControllerObject(entityName: "CharacterObject", sortDescriptorKey: "id", filterKey: String(id)) as? NSFetchedResultsController<CharacterObject>
        }()
        try? characterFetchRequestControllerObject?.performFetch()
        let object = characterFetchRequestControllerObject?.fetchedObjects?.first
        if let object = object {
            deleteCharacterObject(object: object)
        }
    }
    
    private func deleteCharacterObject(object: CharacterObject) {
        object.episode?.forEach({ (episode) in
            DatabaseManager.shared.persistentContainer.viewContext.delete(episode as! NSManagedObject)
        })
        if let location = object.location {
            DatabaseManager.shared.persistentContainer.viewContext.delete(location)
        }
        DatabaseManager.shared.persistentContainer.viewContext.delete(object)
        
        DatabaseManager.shared.saveContext()
    }
    
    func detailDataForTableFromDataBase(indexPath: IndexPath) -> CharacterDetailModel? {
        let object = characterFetchRequestController?.object(at: indexPath)
        guard let id = object?.id, let name = object?.name, let status = object?.status, let species = object?.species, let gender = object?.gender, let image = object?.image else { return nil }
        return CharacterDetailModel(id: Int(id), name: name, status: status, species: species, gender: gender, location: Location(url: ""), image: image, episode: [""], url: "")
    }
    
    func locationDataForTableFromDataBase(indexPath: IndexPath) -> LocationStruct? {
        let id = detailDataForTableFromDataBase(indexPath: indexPath)!.id
        locationFetchRequestController = configureLocationFetchRequestController(filterId: id)
        try? locationFetchRequestController?.performFetch()
        let object = locationFetchRequestController?.fetchedObjects?.first
        guard let name = object?.name, let type = object?.type else { return nil }
        return LocationStruct(name: name, type: type)
    }
    
    func episodeDataForTableFromDataBase(indexPath: IndexPath) -> [Episode] {
        let id = detailDataForTableFromDataBase(indexPath: indexPath)!.id
        episodeFetchRequestController = configureEpisodeFetchRequestController(filterId: id)
        try? episodeFetchRequestController?.performFetch()
        var episodes = [Episode]()
        episodeFetchRequestController?.fetchedObjects?.forEach({ (one) in
            guard let name = one.name, let air_date = one.air_date, let episode = one.episode else { return }
            episodes.append(Episode(name: name, air_date: air_date, episode: episode))
        })
        return episodes
    }
    
    func download(detailData: CharacterDetailModel?, episodesFromNetwork: [Episode], locationData: LocationStruct?) -> Bool {
        if !SettingModel.shared.isSavingOn() {
            delegateForDetail?.showAlert()
            return false
        }
        guard let data = detailData else { return false }
        let characterCard = CharacterObject.object(model: data, context: DatabaseManager.shared.persistentContainer.viewContext)!
        for episode in episodesFromNetwork {
            let currentEpisode = EpisodeObject.object(data: episode, context: DatabaseManager.shared.persistentContainer.viewContext)
            characterCard.addToEpisode(currentEpisode!)
        }
        if let locationData = locationData {
            LocationObject.object(character: characterCard, data: locationData, context: DatabaseManager.shared.persistentContainer.viewContext)
        }
        DatabaseManager.shared.saveContext()
        return true
    }
    
    override init() {
        super.init()
        try? characterFetchRequestController?.performFetch()
        characterFetchRequestController?.delegate = self
        SettingModel.shared.delegate = self
    }
}

extension DatabaseBussinessModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegateForTable?.reloadTable()
    }
}

extension DatabaseBussinessModel: SettingModelDelegate {
    func deleteAll() {
        let entityNames = ["EpisodeObject", "LocationObject", "CharacterObject",]
        for name in entityNames {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try? DatabaseManager.shared.persistentContainer.viewContext.execute(deleteRequest)
            DatabaseManager.shared.saveContext()
        }
        
        try? characterFetchRequestController?.performFetch()
        delegateForTable?.reloadTable()
    }
}
