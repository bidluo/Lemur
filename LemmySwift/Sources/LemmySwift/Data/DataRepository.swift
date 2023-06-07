import Foundation

typealias LocalFetch<T> = () async -> T
typealias RemoteFetch<T> = () async throws -> T

class DataRepository {
    func fetchData<T>(localFetch: @escaping LocalFetch<T>, remoteFetch: @escaping RemoteFetch<T>) async throws -> T {
        let localData = await localFetch()

        if !Reachability.shared.isConnectionHealthy {
            return localData
        }

        return try await remoteFetch()
    }
}
