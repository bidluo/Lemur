import Foundation

protocol RepositoryType {
    
}

extension RepositoryType {
    func fetchFromSources<LocalType, RemoteType, ResultType>(
        localDataSource: @escaping () async throws -> LocalType?,
        remoteDataSource: @escaping () async throws -> RemoteType?,
        transform: @escaping (LocalType?, RemoteType?) async throws -> ResultType?
    ) -> AsyncThrowingStream<ResultType, Error> {
        let stream = AsyncThrowingStream<ResultType, Error> { continuation in
            Task.detached {
                let localData = try await localDataSource()
                if let localResult = try await transform(localData, nil) {
                    continuation.yield(localResult)
                }
                
                let remoteData = try await remoteDataSource()
                if let bothResult = try await transform(localData, remoteData) {
                    continuation.yield(bothResult)
                } else {
                    throw DataFailure.invalidResponse
                }
                
                // TODO: Finish earlier if remote never returns
                continuation.finish()
            }
        }
        
        return stream
    }
}
