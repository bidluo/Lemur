import Foundation

protocol NetworkType {
    var domain: URL { get }
    var urlSession: URLSession { get }
    var asyncActor: AsyncDataTaskActor { get }
}

enum NetworkFailure: LocalizedError {
    case invalidResponse
    case unauthorised, forbidden, notFound, unknown
}


extension DateFormatter {
    public static var iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    public static var iso8601Short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    public static var iso8601Shorter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    public static var iso8601Multi: JSONDecoder.DateDecodingStrategy = .custom { decoder -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        if let date = DateFormatter.iso8601Full.date(from: dateString) {
            return date
        }
        
        if let date = DateFormatter.iso8601Short.date(from: dateString) {
            return date
        }
        
        if let date = DateFormatter.iso8601Shorter.date(from: dateString) {
            return date
        }
        
        throw DecodingError.dataCorruptedError(in: container,
                                               debugDescription: "Cannot decode date string \(dateString)")
    }
}

extension NetworkType {
    
    func perform<T>(http: Spec, for: T.Type) async throws -> T where T: Decodable {
        return try await perform(http: http)
    }
    
    func perform<T>(http: Spec) async throws -> T where T: Decodable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601Multi
        
        let request = try buildRequest(http: http)
        let (data, _response) = try await asyncActor.perform(request: request, urlSession: urlSession)
        
        guard let response = _response as? HTTPURLResponse else {
            throw NetworkFailure.invalidResponse
        }
        
        if response.isSuccessResponse() {
            if data.isEmpty, let emptyJson = "{}".data(using: .utf8) {
                return try jsonDecoder.decode(T.self, from: emptyJson)
            } else {
                return try jsonDecoder.decode(T.self, from: data)
            }
        } else if response.isUnauthorisedResponse() {
            throw NetworkFailure.unauthorised
        } else if response.isForbidden() {
            throw NetworkFailure.forbidden
        } else if response.isNotFound() {
            throw NetworkFailure.notFound
        } else {
            throw NetworkFailure.unknown
        }
    }
    
    func buildRequest(http: Spec) throws -> URLRequest {
        guard http.path.isEmpty == false else {
            throw RemoteError.invalidInput
        }
        
        guard let sanitisedPath = http.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw RemoteError.invalidPath
        }
        
        var components = URLComponents(url: domain.appendingPathComponent(sanitisedPath), resolvingAgainstBaseURL: false)
        
        let queryItems = http.query.filter { $0.value != nil }
        if queryItems.isEmpty == false {
            components?.queryItems = queryItems
        }
        
        guard let url = components?.url else {
            throw RemoteError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = http.method.text
        request.httpBody = http.method.body
        
        if let contentType = http.contentType {
            request.addValue(contentType.rawValue, forHTTPHeaderField: ContentType.key)
        }
        
        return request
    }
}

actor AsyncDataTaskActor {
    typealias DataResponse = (Data, URLResponse)
    typealias TaskEntry = (task: Task<DataResponse, Error>, expiryDate: Date)

    private var activeTasks = [URLRequest: TaskEntry]()
    private let taskLifetime: TimeInterval

    init(taskLifetime: TimeInterval = 120) {
        self.taskLifetime = taskLifetime
    }

    /// Asynchronously performs a network request using the provided `URLRequest` and `URLSession`.
    ///
    /// This function creates a task to perform the request and keeps track of active tasks to ensure
    /// that the same request is not performed more than once at a time. If a task for the same request
    /// is already active, this function will return the result of the existing task.
    ///
    /// Each task is given a lifetime, after which it is considered expired. Expired tasks are cleaned
    /// from the cache automatically before each new request.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to perform.
    ///   - urlSession: The `URLSession` to use for performing the request.
    ///
    /// - Returns: A `DataResponse` tuple containing the response data and the `URLResponse` object.
    ///   This tuple is delivered asynchronously via the returned `Task`.
    ///
    /// - Throws: If the network request fails, this function throws an error. The specific error
    ///   thrown depends on the nature of the failure.
    func perform(request: URLRequest, urlSession: URLSession) async throws -> DataResponse {
        cleanExpiredTasks()

        if let existingTask = activeTasks[request]?.task {
            return try await existingTask.value
        }

        let task = Task<DataResponse, Error> {
            let (data, response) = try await urlSession.data(for: request)
            return (data, response)
        }

        let expiryDate = Date().addingTimeInterval(taskLifetime)
        activeTasks[request] = (task, expiryDate)

        let result = try await task.value
        activeTasks[request] = nil
        return result
    }

    private func cleanExpiredTasks() {
        let now = Date()
        activeTasks = activeTasks.filter { _, entry in
            return now < entry.expiryDate
        }
    }
}
