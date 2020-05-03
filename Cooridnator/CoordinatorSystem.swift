import UIKit

/// Namespace to encapsualte the `Event`, `State`, and `Action` for an `EventCooridinator`
public protocol CoordinatorSystem {

    /// Convenience alias for an `EventCoordinator` of this type
    typealias Coordinator = EventCoordinator<Self>

    /// Convenience alias for an `Update` of this type
    typealias Update = Coordinator.Update

    /// Possible events that can occur in this system
    associatedtype Event

    /// State that describes the system
    associatedtype State

    /// Possible actions needed for async calls or directives to the subscribers
    associatedtype Action
}
