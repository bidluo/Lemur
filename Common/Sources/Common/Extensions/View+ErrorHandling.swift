import Foundation
import SwiftUI
import Observation

public extension View {
    func executing(
        _ action: @escaping () async throws -> (),
        errorHandler: ErrorHandling,
        completion: (() -> ())? = nil
    ) {
        self.executing(action: action, errorHandler: errorHandler, completion: completion)
    }
    
    func executing<T>(
        action: @escaping () async throws -> T,
        errorHandler: ErrorHandling,
        completion: ((T) -> ())? = nil
    ) {
        Task {
            do {
                let value = try await action()
                DispatchQueue.main.async {
                    completion?(value)
                }
            } catch {
                errorHandler.handle(error: error)
            }
        }
    }
    
    func executing(
        action: @escaping () async throws -> (),
        errorHandler: ErrorHandling,
        completion: (() -> ())? = nil
    ) {
        Task {
            do {
                try await action()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                errorHandler.handle(error: error)
            }
        }
    }
    
    func executing(
        action: @escaping () async throws -> (),
        errorHandler: ErrorHandling,
        completion: (() async throws -> ())? = nil
    ) {
        Task {
            do {
                try await action()
                try await completion?()
            } catch {
                errorHandler.handle(error: error)
            }
        }
    }
    
    func executing(
        _ action: @escaping () async throws -> (),
        errorHandler: ErrorHandling,
        completion: (() -> ())? = nil,
        catching: @escaping (Error) -> (Bool)
    ) {
        Task {
            do {
                try await action()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                if catching(error) == false {
                    errorHandler.handle(error: error)
                }
            }
        }
    }
    
    func executing(
        action: @escaping () async throws -> (),
        errorHandler: ErrorHandling,
        completion: (() -> ())? = nil,
        catching: @escaping (Error) -> (Bool)
    ) {
        Task {
            do {
                try await action()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                if catching(error) == false {
                    errorHandler.handle(error: error)
                }
            }
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
