import Foundation
import CoreData

@objc(CharacterEntity)
public class CharacterEntity: NSManagedObject {
    // Преобразование объекта персонажа в NSManagedObject
    static func object(character: Character) -> CharacterEntity {
        let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: CharacterEntity.self), in: DatabaseManager.shared.persistentContainer.viewContext)!

        let characterObject = CharacterEntity(entity: entityDescription, insertInto: DatabaseManager.shared.persistentContainer.viewContext)

        characterObject.id = Int64(character.id)
        characterObject.name = character.name
        characterObject.status = character.status.rawValue.lowercased()
        characterObject.species = character.species
        characterObject.gender = character.gender.rawValue.lowercased()
        characterObject.imageURL = character.imageURL

        return characterObject
    }
}
