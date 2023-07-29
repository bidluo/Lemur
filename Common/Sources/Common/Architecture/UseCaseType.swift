import Foundation

public protocol UseCaseType {
    associatedtype Input
    associatedtype Result
    
    init()
    
    func call(input: Input) async throws -> Result
}

extension UseCaseType where Input == Void {
    @discardableResult
    public func call() async throws -> Result {
        try await self.call(input: ())
    }
}

extension UseCaseType where Result == Void {
    @discardableResult
    public func call(input: Input) async throws -> Result {
        try await self.call(input: input)
    }
}
