import Foundation
import XCTest

@testable import LemmySwift

final class SpecTests: XCTestCase {
    
    // MARK: - Mock Spec
    struct SpecStub: HTTP {
        var method: HTTPMethod
        var path: String
        var query: [URLQueryItem]
        var contentType: ContentType?
    }
    
    struct MockRepository: Spec {
        var domain: URL
    }
    
    // MARK: - Test buildRequest(http:) with valid spec
    func testBuildRequest() {
        // Given
        let http = SpecStub(
            method: .get,
            path: "/api/posts",
            query: [
                URLQueryItem(name: "category", value: "technology"),
                URLQueryItem(name: "limit", value: "10"),
            ],
            contentType: .json
        )
        let repository = MockRepository(domain: URL(string: "https://example.com")!)
        
        // When
        let request = try! repository.buildRequest(http: http)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://example.com/api/posts?category=technology&limit=10")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
    }
    
    // MARK: - Test buildRequest(http:) with empty query
    func testBuildRequestWithEmptyQuery() {
        // Given
        let http = SpecStub(
            method: .get,
            path: "/api/posts",
            query: [],
            contentType: .json
        )
        let repository = MockRepository(domain: URL(string: "https://example.com")!)

        // When
        let request = try! repository.buildRequest(http: http)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://example.com/api/posts")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
    }
    
    // MARK: - Test buildRequest(http:) with empty path
    func testBuildRequestWithInvalidPath() {
        // Given
        let http = SpecStub(
            method: .get,
            path: "", // Empty path
            query: [
                URLQueryItem(name: "category", value: "technology"),
                URLQueryItem(name: "limit", value: "10"),
            ],
            contentType: .json
        )
        let repository = MockRepository(domain: URL(string: "https://example.com")!)

        // When/Then
        XCTAssertThrowsError(try repository.buildRequest(http: http)) { error in
            XCTAssertEqual(error as? SpecError, SpecError.invalidInput)
        }
    }
}
