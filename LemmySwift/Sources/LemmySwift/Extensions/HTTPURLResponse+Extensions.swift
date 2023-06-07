import Foundation

internal extension HTTPURLResponse {
    func isSuccessResponse() -> Bool {
        return 200..<300 ~= statusCode
    }

    func isServerErrorResponse() -> Bool {
        return 500..<600 ~= statusCode
    }

    func isUnauthorisedResponse() -> Bool {
        return statusCode == 401
    }

    func isForbidden() -> Bool {
        return statusCode == 403
    }

    func isNotFound() -> Bool {
        return statusCode == 404
    }
}
