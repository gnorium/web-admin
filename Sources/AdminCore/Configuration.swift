#if !os(WASI)

import Foundation

/// Configuration for the AdminCore package.
public struct Configuration: Sendable {
    /// The base route for the admin console (e.g., "/admin-console").
    public var baseRoute: String
    
    public init(baseRoute: String = "/admin-console") {
        self.baseRoute = baseRoute
    }
    
    /// Global shared configuration.
    /// WARNING: This should only be modified during application initialization before any requests are handled.
    public nonisolated(unsafe) static var shared = Configuration()
}

#endif
