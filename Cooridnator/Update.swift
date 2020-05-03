import Foundation
import Combine

extension EventCoordinator {

    /// Struct that gets sent to `Subscribers` and subscribed closures.
    public struct Update {

        /// Function signature similar to the `EventCoordinator.notify`
        public typealias Notify = PassthroughSubject<Event, Never>

        /// Actions requested by the handler.
        public let actions: [Action]

        /// Last known state of the coordinator.
        public let state: State

        /// Convenience function to easily notify new events to the coordinator.
        public let notify: Notify

        /// Creates an Update with the specified parameters.
        /// - Parameters:
        ///   - state: Last known state of the coordinator.
        ///   - actions: Actions requested by the handler.
        ///   - notify: Convenience closure to easily notify new events to the coordinator.
        public init(state: State, actions: [Action], notify: Notify) {
            self.state = state
            self.actions = actions
            self.notify = notify
        }
    }
}
