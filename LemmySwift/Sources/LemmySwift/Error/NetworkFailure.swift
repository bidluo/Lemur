import Foundation

enum NetworkFailure: LocalizedError {
    case invalidResponse
    case unauthorised, forbidden, notFound, unknown
}
