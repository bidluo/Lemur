import Foundation
import SwiftUI
import Observation

struct DebouncingTaskViewModifier<ID: Equatable>: ViewModifier {
    let id: ID?
    let priority: TaskPriority
    let duration: Duration?
    let errorHandler: ErrorHandling
    let task: @Sendable () async throws -> Void
    
    init(
        id: ID?,
        priority: TaskPriority = .userInitiated,
        duration: Duration? = nil,
        errorHandler: ErrorHandling,
        task: @Sendable @escaping () async throws -> Void
    ) {
        self.id = id
        self.priority = priority
        self.duration = duration
        self.errorHandler = errorHandler
        self.task = task
    }
    
    func body(content: Content) -> some View {
        if let _id = id {
            content.task(id: id, priority: priority) {
                do {
                    if let _duration = duration {
                        try await Task.sleep(for: _duration)
                    }
                    try await task()
                } catch {
                    switch error {
                    case is CancellationError: break
                    default: errorHandler.handle(error: error)
                    }
                }
            }
        } else {
            content.task(priority: priority) {
                do {
                    if let _duration = duration {
                        try await Task.sleep(for: _duration)
                    }
                    try await task()
                } catch {
                    switch error {
                    case is CancellationError: break
                    default: errorHandler.handle(error: error)
                    }
                }
            }
        }
    }
}

public extension View {
    func task<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .userInitiated,
        duration: Duration? = nil,
        errorHandler: ErrorHandling,
        task: @Sendable @escaping () async throws -> Void
    ) -> some View {
        modifier(
            DebouncingTaskViewModifier(
                id: id,
                priority: priority,
                duration: duration,
                errorHandler: errorHandler,
                task: task
            )
        )
    }
    
    func task(
        priority: TaskPriority = .userInitiated,
        duration: Duration? = nil,
        errorHandler: ErrorHandling,
        task: @Sendable @escaping () async throws -> Void
    ) -> some View {
        modifier(
            DebouncingTaskViewModifier<Int>(
                id: nil,
                priority: priority,
                duration: duration,
                errorHandler: errorHandler,
                task: task
            )
        )
    }
    
    private func executeAction(
        _ action: @escaping () async throws -> (),
        after duration: Duration? = nil,
        errorHandler: ErrorHandling,
        completion: (() -> ())? = nil,
        catching: ((Error) -> (Bool))? = nil
    ) {
        Task(priority: .userInitiated) {
            do {
                if let _duration = duration {
                    try await Task.sleep(for: _duration)
                }
                try await action()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                if catching?(error) == false {
                    errorHandler.handle(error: error)
                }
            }
        }
    }
    
    func executing(
        action: @escaping () async throws -> (),
        after duration: Duration? = nil,
        errorHandler: ErrorHandling,
        completion: (() -> ())? = nil
    ) {
        executeAction(action, after: duration, errorHandler: errorHandler, completion: completion, catching: nil)
    }
    
    func executing(
        action: @escaping () async throws -> (),
        errorHandler: ErrorHandling,
        completion: (() -> ())? = nil,
        catching: @escaping (Error) -> (Bool)
    ) {
        executeAction(action, after: nil, errorHandler: errorHandler, completion: completion, catching: catching)
    }
}

@Observable
public class ErrorHandling {
    var currentAlert: ErrorAlert?
    
    public init() {
        
    }
    
    func handle(error: Error) {
        DispatchQueue.main.async {
            self.currentAlert = ErrorAlert(message: error.localizedDescription)
        }
    }
}

struct ErrorAlert: Identifiable {
    var id = UUID()
    var message: String
    var dismissAction: (() -> Void)?
}

struct HandleErrorsByShowingAlertViewModifier: ViewModifier {
    @State var errorHandling: ErrorHandling
    
    func body(content: Content) -> some View {
        content
            .background(EmptyView()
                .alert(item: $errorHandling.currentAlert) { currentAlert in
                    Alert(
                        title: Text("An error occured"),
                        message: Text(currentAlert.message),
                        dismissButton: .default(Text("Dismiss")) {
                            currentAlert.dismissAction?()
                        }
                    )
                }
            )
    }
}

public extension View {
    func withErrorHandling(errorHandling: ErrorHandling) -> some View {
        modifier(HandleErrorsByShowingAlertViewModifier(errorHandling: errorHandling))
    }
}
