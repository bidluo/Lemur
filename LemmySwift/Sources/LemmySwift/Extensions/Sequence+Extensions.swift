import Foundation

public extension Sequence {
    
    /// Asynchronously maps the elements of a sequence to a new array using a given async closure.
    ///
    /// - Parameter transform: An async closure that takes an element of this sequence as its argument and returns a transformed value.
    /// - Returns: An array containing the transformed elements.
    /// - Throws: Any error that occurs within the `transform` closure.
    func asyncMap<T>(_ transform: @escaping (Element) async throws -> T) async throws -> [T] {
        var results = [T]()
        for element in self {
            let transformed = try await transform(element)
            results.append(transformed)
        }
        return results
    }
    
    /// Asynchronously maps the elements of a sequence to a new array using a given async closure.
    ///
    /// - Parameter transform: An async closure that takes an element of this sequence as its argument and returns a transformed value.
    /// - Returns: An array containing the transformed elements.
    func asyncMap<T>(_ transform: @escaping (Element) async -> T) async -> [T] {
        var results = [T]()
        for element in self {
            let transformed = await transform(element)
            results.append(transformed)
        }
        return results
    }
    
    /// Asynchronously maps the elements of a sequence to a new array of optional values, then unwraps and includes non-nil results.
    ///
    /// - Parameter transform: An async closure that takes an element of this sequence as its argument and returns an optional transformed value.
    /// - Returns: An array containing the non-nil transformed elements.
    /// - Throws: Any error that occurs within the `transform` closure.
    func asyncCompactMap<T>(_ transform: @escaping (Element) async throws -> T?) async throws -> [T] {
        var results = [T]()
        for element in self {
            if let transformed = try await transform(element) {
                results.append(transformed)
            }
        }
        return results
    }
    
    /// Asynchronously maps the elements of a sequence to a new array of optional values, then unwraps and includes non-nil results.
    ///
    /// - Parameter transform: An async closure that takes an element of this sequence as its argument and returns an optional transformed value.
    /// - Returns: An array containing the non-nil transformed elements.
    func asyncCompactMap<T>(_ transform: @escaping (Element) async -> T?) async -> [T] {
        var results = [T]()
        for element in self {
            if let transformed = await transform(element) {
                results.append(transformed)
            }
        }
        return results
    }
}
