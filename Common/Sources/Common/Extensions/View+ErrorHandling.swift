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
            content.task(id: _id, priority: priority) {
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
    
    /// Executes a given asynchronous action that might throw an error, with an optional delay.
    ///
    /// This function is suitable for use with SwiftUI's `.task` modifier, as it enables the platform to
    /// automatically cancel the operation when required.
    ///
    /// - Parameters:
    ///   - action: An async closure that contains the code to execute.
    ///   - duration: Optional delay before executing the action, specified as a `Duration`.
    ///   - errorHandler: An object conforming to `ErrorHandling` for handling errors.
    ///   - completion: An optional closure to call upon successful execution of the action.
    ///   - catching: An optional closure that gets invoked if `action` throws an error. Return `true` to swallow the error, `false` to proceed to `errorHandler`.
    ///
    func executingTask(
        action: @escaping () async throws -> (),
        after duration: Duration? = nil,
        errorHandler: ErrorHandling,
        completion: (() -> ())? = nil,
        catching: ((Error) -> (Bool))? = nil
    ) async {
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
    
    /// Executes a given asynchronous action, similar to `executingTask`, but with a user-initiated priority.
    ///
    /// This function is ideal for cases where SwiftUI's `.task` modifier is not used, such as within buttons.
    ///
    /// - Parameters:
    ///   - action: An async closure that contains the code to execute.
    ///   - duration: Optional delay before executing the action, specified as a `Duration`.
    ///   - errorHandler: An object conforming to `ErrorHandling` for handling errors.
    ///   - completion: An optional closure to call upon successful execution of the action.
    ///   - catching: An optional closure that gets invoked if `action` throws an error. Return `true` to swallow the error, `false` to proceed to `errorHandler`.
    ///
    func executing(
        action: @escaping () async throws -> (),
        after duration: Duration? = nil,
        errorHandler: ErrorHandling,
        completion: (() -> ())? = nil,
        catching: ((Error) -> (Bool))? = nil
    ) {
        Task(priority: .userInitiated) {
            await executingTask(
                action: action,
                after: duration,
                errorHandler: errorHandler,
                completion: completion,
                catching: catching
            )
        }
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
