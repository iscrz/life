import Foundation
import Combine

/// State machine to handle a unidirectional data flow of event and actions.
public final class EventCoordinator<System: CoordinatorSystem> {

    /// Convenience alias for CoordinatorSystem.Event
    public typealias Event = System.Event

    /// Convenience alias for CoordinatorSystem.State
    public typealias State = System.State

    /// Convenience alias for CoordinatorSystem.Action
    public typealias Action = System.Action

    /// Current state of the EventCoordinator.
    
    let input = PassthroughSubject<Event, Never>()
    
    private let eventPublisher = PassthroughSubject<Event, Never>()
    private let statePublisher: CurrentValueSubject<State, Never>
    private let actionPublisher = PassthroughSubject<System.Update, Never>()

    private var subscriptions = [AnyCancellable]()
    private let workQueue = DispatchQueue(label: "com.isaac.eventCoordinator")
    private var eventHandler: EventHandler<System>
    
    public var events: AnyPublisher<Event, Never> {
        eventPublisher
            .eraseToAnyPublisher()
    }
    
    public var state2: AnyPublisher<State, Never> {
        statePublisher
            .eraseToAnyPublisher()
    }
    
    public var updates: AnyPublisher<System.Update, Never> {
        actionPublisher
            .eraseToAnyPublisher()
    }

    /// Creates an `EventCoordinator` with the following parameters.
    /// - Parameter eventHandler: `EventHandler` implementation to coordinate events and actions on
    ///   - state: Initial state for the coordinator
    public init(_ eventHandler: EventHandler<System>, state: State) {
        self.eventHandler = eventHandler
        self.statePublisher = CurrentValueSubject<State, Never>(state)
        
        input
            .receive(on: workQueue)
            .sink { [weak self] event in
                guard let self = self else { return }
                self.eventPublisher.send(event)
                
                var state = self.statePublisher.value
                let actions = self.eventHandler.handle(event: event, state: &state)
                self.statePublisher.send(state)

                let update = Update(state: state, actions: actions, notify: self.input)
                self.actionPublisher.send(update)
            }
            .store(in: &subscriptions)
    }

    // MARK: - Event Notifying

    /// Passes along the event to the `EventHandler`. Afterwhich the actions and state will be passed along to all subscribers.
    /// - Parameter event: Event for the `EventHandler`
    public final func notify(event: Event) {
        input.send(event)
    }
}

extension Publisher {
    func dothis<S>(event: S.Event, system: S) where S: CoordinatorSystem {
        
    }
}
