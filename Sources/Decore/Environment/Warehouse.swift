//
//  Warehouse.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

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

    /// Returns the storage for the object type
    public static func storage<T>(for type: T.Type) -> Storage {
        /// to be changed when introducing multi storage support
        Warehouse[.defaultStorage]
    }

    /// Returns the storage for the object
    public static func storage<T>(for type: T) -> Storage {
        /// to be changed when introducing multi storage support
        Warehouse[.defaultStorage]
    }

    /// Storage unique identifier.
    public enum Key: Hashable {
        case defaultStorage
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


