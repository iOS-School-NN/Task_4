import CoreData

class DatabaseManager {

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EPAM_Task4")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

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

    // Метод ответственный за получение объекта персонажа из БД по его идентификатору
    func getCharacterObject(id: Int) -> CharacterEntity? {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))

        return try? persistentContainer.viewContext.fetch(fetchRequest).first
    }

    // Метод ответственный за получение объекта локации
    // Если объект локации уже есть в базе данных, то возвращает его
    private func getLocationObject(location: Location) -> LocationEntity {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(location.id ?? 0))
        let locations = try? persistentContainer.viewContext.fetch(fetchRequest)

        guard let location = locations?.first else {
            return LocationEntity.object(location: location)
        }

        return location
    }

    // Метод ответственный за получение объекта эпизода
    // Если объект эпизода уже есть в базе данных, то возвращает его
    private func getEpisodeObject(episode: Episode) -> EpisodeEntity {
        let fetchRequest: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(episode.id))

        let episodes = try? persistentContainer.viewContext.fetch(fetchRequest)

        guard let episode = episodes?.first else {
            return EpisodeEntity.object(episode: episode)
        }

        return episode
    }

    // Сохранение персонажа в базу данных
    func saveCharacter(character: Character) {
        let characterObject = CharacterEntity.object(character: character)

        let locationObject = getLocationObject(location: character.location)
        locationObject.addToCharacter(characterObject)

        for episode in character.episodes {
            let episodeObject = getEpisodeObject(episode: episode)
            episodeObject.addToCharacter(characterObject)
            characterObject.addToEpisodes(episodeObject)
        }

        saveContext()
    }

    // Метод ответственный за удаление персонажа из базы данных
    // Если в эпизоде или локации этот персонаж является единственным, то они тоже удаляются
    func removeCharacter(character: Character) {
        guard let characterObject = getCharacterObject(id: character.id) else {
            return
        }

        if let locationObject = characterObject.location {
            if locationObject.character?.count ?? 0 <= 1 {
                persistentContainer.viewContext.delete(locationObject)
            } else {
                locationObject.removeFromCharacter(characterObject)
            }
        }

        if let episodeObjects = characterObject.episodes?.allObjects as? [EpisodeEntity] {
            for episodeObject in episodeObjects {
                if episodeObject.character?.count ?? 0 <= 1 {
                    persistentContainer.viewContext.delete(episodeObject)
                } else {
                    episodeObject.removeFromCharacter(characterObject)
                }
            }
        }

        persistentContainer.viewContext.delete(characterObject)
        saveContext()
    }

    // Удаление всех данных по названию сущности
    private func deleteAllData(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                persistentContainer.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }

    // Удаление всех сущностей из базы данных
    func clearDatabase() {
            let entities = [CharacterEntity.self, LocationEntity.self, EpisodeEntity.self]

            entities.forEach({ entity in
                deleteAllData(String(describing: entity))
                saveContext()
            })
        }

    // Сохранение контекста
    private func saveContext () {
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

    private init() {}
    static let shared = DatabaseManager()
}
