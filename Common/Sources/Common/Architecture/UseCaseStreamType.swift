import Foundation

public protocol UseCaseStreamType {
    associatedtype Input
    associatedtype Result
    
    init()
    
    func call(input: Input) async -> AsyncThrowingStream<Result, Error>
}

extension UseCaseStreamType where Input == Void {
    @discardableResult
    public func call() async -> AsyncThrowingStream<Result, Error> {
        await self.call(input: ())
    }
}

extension UseCaseStreamType {
    @MainActor
    public func mapAsyncStream<Input, Output>(
        _ stream: AsyncThrowingStream<Input, Error>,
        transform: @MainActor @escaping (Input) throws -> Output
    ) -> AsyncThrowingStream<Output, Error> {
        return AsyncThrowingStream<Output, Error> { continuation in
            Task {
                do {
                    for try await input in stream {
                        let output = try transform(input)
                        continuation.yield(output)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
