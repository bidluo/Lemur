import Foundation
import SwiftData

public actor UserRepositoryLocal: ModelActor {
    nonisolated public let executor: any ModelExecutor
    
    init(container: ModelContainer) {
        let context = ModelContext(container)
        executor = DefaultModelExecutor(context: context)
    }
    
    func getPerson(siteUrl: URL, username: String) -> Person? {
        var userFetch = FetchDescriptor<Person>(
            predicate: #Predicate { $0.name == username }
        )
        
        userFetch.fetchLimit = 1
        userFetch.includePendingChanges = true
        
        guard let fetchId = try? context.fetchIdentifiers(userFetch).first,
              let user = context.model(for: fetchId) as? Person
        else {
            return nil
        }
        
        return user
    }
    
    func getPeople(withIds peopleIds: [String]) throws -> [Person] {
        let userFetch = FetchDescriptor<Person>(
            predicate: #Predicate { peopleIds.contains($0.id) }
        )
        
        return try context.fetch(userFetch)
    }
    
    func saveUser(siteUrl: URL, user: PersonDetailResponse?) -> Person? {
        guard let username = user?.personView?.person?.name else { return nil }
        
        var siteFetch = FetchDescriptor<Site>()
        
        siteFetch.includePendingChanges = true
        
        let sites = try? context.fetch(siteFetch)
        
        // `FetchDescriptor` `#Predicate` doesn't work with URL
        guard let site = sites?.first(where: { $0.url == siteUrl }) else {
            return nil
        }
        
        let localPerson: Person
        if let existingPerson = getPerson(siteUrl: siteUrl, username: username) {
            existingPerson.update(with: user?.personView?.person)
            localPerson = existingPerson
        } else if let newPerson = Person(remote: user?.personView?.person, idPrefix: site.id) {
            localPerson = newPerson
            context.insert(newPerson)
        } else {
            return nil
        }
        
        localPerson.site = site
        
        return localPerson
    }
}
