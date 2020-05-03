import Foundation

/// State machine for the EventCoordinator flow.
open class EventHandler<E: Event, S: State, A: Action> {

    /// Convenience alias for CoordinatorSystem.Event
    public typealias Event = E

    /// Convenience alias for CoordinatorSystem.Action
    public typealias State = S

    /// Convenience alias for CoordinatorSystem.Action
    public typealias Action = A

    /// Creates an EventHandler with no parameters.
    public init() { }

    /// Handles the provided event and updates the state and action array
    /// - Parameters:
    ///   - event: Event to handle
    ///   - state: `inout State` variable that the handler can modify
    ///   - actions: `inout [Action]` variable that the handler can append actions to
    open func handle(event: Event, state: inout State) -> [Action] {
        return []
    }
}
