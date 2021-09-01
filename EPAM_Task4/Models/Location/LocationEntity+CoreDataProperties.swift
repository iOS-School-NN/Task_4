import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var id: Int64
    @NSManaged public var character: NSSet?

}

// MARK: Generated accessors for character
extension LocationEntity {

    @objc(addCharacterObject:)
    @NSManaged public func addToCharacter(_ value: CharacterEntity)

    @objc(removeCharacterObject:)
    @NSManaged public func removeFromCharacter(_ value: CharacterEntity)

    @objc(addCharacter:)
    @NSManaged public func addToCharacter(_ values: NSSet)

    @objc(removeCharacter:)
    @NSManaged public func removeFromCharacter(_ values: NSSet)

}
