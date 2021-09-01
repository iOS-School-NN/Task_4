import Foundation
import CoreData


extension EpisodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeEntity> {
        return NSFetchRequest<EpisodeEntity>(entityName: "EpisodeEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var airDate: String?
    @NSManaged public var episode: String?
    @NSManaged public var id: Int64
    @NSManaged public var character: NSSet?

}

// MARK: Generated accessors for character
extension EpisodeEntity {

    @objc(addCharacterObject:)
    @NSManaged public func addToCharacter(_ value: CharacterEntity)

    @objc(removeCharacterObject:)
    @NSManaged public func removeFromCharacter(_ value: CharacterEntity)

    @objc(addCharacter:)
    @NSManaged public func addToCharacter(_ values: NSSet)

    @objc(removeCharacter:)
    @NSManaged public func removeFromCharacter(_ values: NSSet)

}
