import Foundation
/// Warehouse id a static storage of ``Storage``.
/// Access:
/// ```swift
/// let storage = Warehouse[.defaultStorage]
/// // returns the default storage
/// ```
///
/// **To Be Implemented:**
/// ```swift
/// let sceneStorage = Warehouse[.storage(uniqueStorageID)]
/// ```
///
public final class Warehouse {


    /// Returns the storage for the object
    public static func storage<T>(for type: T.Type) -> Storage {
        /// to be changed when introducing multi storage support
        Warehouse[.defaultStorage]
    }

    /// Storage unique identifier.
    public enum Key: Hashable {
        case defaultStorage

        // Point of improvement: Unique identifier to use in persistence layer
        // e.g. file name, data base table name etc.
        // TODO: case storage(UniqueIDPersistentAcrossSessions)
    }

    public static subscript(_ key: Key) -> Storage {
        get {
            guard let storageForKey = warehouse[key] else {
                let newStorage = Storage()
                warehouse[key] = newStorage
                return newStorage
            }
            return storageForKey
        }
        set {
            warehouse[key] = newValue
        }
    }


    private static var warehouse: [Key: Storage] = [
        .defaultStorage: Storage()
    ]
}


