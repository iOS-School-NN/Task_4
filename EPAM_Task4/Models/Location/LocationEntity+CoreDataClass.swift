import Foundation
import CoreData

@objc(LocationEntity)
public class LocationEntity: NSManagedObject {

    // Преобразование объекта локации в NSManagedObject
    static func object(location: Location) -> LocationEntity {
        let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: LocationEntity.self), in: DatabaseManager.shared.persistentContainer.viewContext)!

        let locationObject = LocationEntity(entity: entityDescription, insertInto: DatabaseManager.shared.persistentContainer.viewContext)

        locationObject.id = Int64(location.id ?? 0)
        locationObject.name = location.name
        locationObject.type = location.type

        return locationObject
    }
}

extension Location {

    // Инициализация объекта локации из NSManagedObject
    init(locationObject: LocationEntity) {
        self.id = Int(locationObject.id)
        self.name = locationObject.name
        self.type = locationObject.type
        self.url = ""
    }
}
