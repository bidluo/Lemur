import Foundation

public protocol UserRepositoryType {
    func getPerson(siteUrl: URL, username: String) async -> AsyncThrowingStream<Person, Error>
    func getPeople(withIds peopleIds: [String]) async throws -> [Person]
}

class UserRepository: UserRepositoryType, RepositoryType {
    
    private let remote: UserRepositoryRemote
    private let local: UserRepositoryLocal
    
    init(remote: UserRepositoryRemote, local: UserRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    func getPerson(siteUrl: URL, username: String) async -> AsyncThrowingStream<Person, Error> {
        fetchFromSources(
            localDataSource: { await self.local.getPerson(siteUrl: siteUrl, username: username) },
            remoteDataSource: {
                let person = try await self.remote.getPerson(baseUrl: siteUrl, username: username)
                let savedPerson = await self.local.saveUser(siteUrl: siteUrl, user: person)
                return savedPerson
            },
            transform: { local, remote in
                return remote ?? local
            })
    }
    
    func getPeople(withIds peopleIds: [String]) async throws -> [Person] {
        return try await local.getPeople(withIds: peopleIds)
    }
}
