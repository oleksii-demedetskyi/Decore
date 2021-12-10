//
//  Storage.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// **TBD**: Storage for ``Container``s.
/// Each time the value is read from the storage, it builds a dependency graph.
/// When value of one ``Container`` changes, storage enumerates through all dependencies
/// and these will recalculate their value calling the ``Container/initialValue()`` function.
public final class Storage {

    /// A unique key for the container.
    public enum Key: Hashable {
        case container(AnyHashable)
        case group(AnyHashable)
        case groupItem(AnyHashable, id: AnyHashable)
    }

    /// Raw storage with all the ``Container``s
    var storage: [Key: Any] = [:]

    /// TBD
    var dependencies: [Key: [Key]] = [:]

    /// Raw storage with all the ``Observation``s
    var observations: [Storage.Key: ObservationStorage] = [:]

    /// Inserts ``Observation`` into ``ObservationStorage`` for given container ``Key``
    func insertObservation(_ observation: Observation, for container: Key, context: Context) {
        let observationStorage = observations[container, default: ObservationStorage()]
        observationStorage.insert(observation)
        observations[container] = observationStorage
    }

    func insertDependency(_ depender: Key, for key: Key) {
        var dependencies = self.dependencies[key, default: []]
        dependencies.append(depender)
        self.dependencies[key] = dependencies
    }


    /// Reads the value from storage.
    /// Uses `fallbackValue` in cases when value isn't in storage.
    /// if `shouldStoreFallbackValue` is `true` writes `fallbackValue` into storage
    /// Adds dependency of `depender` for key that is being read.
    /// - Returns: Value
    func readValue<Value>(
        at destination: Key,
        fallbackValue: () -> Value,
        context: Context,
        shouldStoreFallbackValue: Bool = true,
        depender: Key? = nil
    ) -> Value {
        if let depender = depender {
            insertDependency(depender, for: destination)
        }
        guard let value = storage[destination] as? Value
        else {
            let newValue = fallbackValue()
            if shouldStoreFallbackValue {
                update(value: newValue, atKey: destination)
            }
            return newValue
        }
        return value
    }

    public func update(value: Any, atKey destination: Key) {
        willChangeValue(destination)
        invalidateValue(at: destination)
        storage[destination] = value
        didChangeValue(destination)
    }

    private func invalidateValue(at key: Storage.Key) {
        storage.removeValue(forKey: key)
        for depender in dependencies[key] ?? [] {
            storage.removeValue(forKey: depender)
        }
    }

    private func willChangeValue(_ destination: Key) {
        observations[destination]?.willChangeValue()
        for dependency in dependencies[destination] ?? [] {
            observations[dependency]?.willChangeValue()
        }
        invalidateValue(at: destination)
    }

    private func didChangeValue(_ destination: Key) {
        observations[destination]?.didChangeValue()
    }
}


extension Storage.Key: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .container(let name): return "\(name)"
        case .group(let name): return "\(name)"
        case .groupItem(let name, let id): return "\(name) | at id: \(id)"
        }
    }
}
