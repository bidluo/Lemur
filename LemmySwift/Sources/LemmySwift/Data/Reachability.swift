import Network
import Foundation
import os.log

class Reachability {
    static let shared = Reachability()

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global()
    private var healthCheckURL: URL?
    private let logger: OSLog

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    var isExpensive: Bool {
        return monitor.currentPath.isExpensive
    }
    
    var isConnectionHealthy: Bool {
        return isConnected && isServerReachable
    }

    private var isServerReachable: Bool = true

    private init() {
        logger = OSLog(subsystem: "LemmySwift", category: "network")
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] _ in
            self?.pathUpdateHandler()
        }
        monitor.start(queue: queue)

    }

    private func pathUpdateHandler() {
        if isConnected {
            os_log("Network connection is available.", log: logger, type: .info)
            if isExpensive {
                os_log("The network connection is considered expensive, such as Cellular or Personal Hotspot.", log: logger, type: .info)
            }
        } else {
            os_log("No network connection.", log: logger, type: .info)
            reportServerFailure()
        }
    }

    func reportServerFailure() {
        isServerReachable = false
        os_log("Server is not reachable", log: logger, type: .error)
    }

    func reportServerSuccess() {
        isServerReachable = true
        os_log("Server is reachable", log: logger, type: .info)
    }
}
