import Foundation
import CoreData

@objc(EpisodeEntity)
public class EpisodeEntity: NSManagedObject {

    // Преобразование объекта эпизода в NSManagedObject
    static func object(episode: Episode) -> EpisodeEntity {
        let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: EpisodeEntity.self), in: DatabaseManager.shared.persistentContainer.viewContext)!

        let episodeObject = EpisodeEntity(entity: entityDescription, insertInto: DatabaseManager.shared.persistentContainer.viewContext)

        episodeObject.id = Int64(episode.id)
        episodeObject.name = episode.name
        episodeObject.airDate = episode.airDate
        episodeObject.episode = episode.episode

        return episodeObject
    }
}

extension Episode {
    // Инициализация объекта эпизода из NSManagedObject
    init(episodeObject: EpisodeEntity) {
        self.id = Int(episodeObject.id)
        self.name = episodeObject.name ?? ""
        self.airDate = episodeObject.airDate ?? ""
        self.episode = episodeObject.episode ?? ""
    }
}
