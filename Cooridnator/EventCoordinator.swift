import Foundation
import Combine


public protocol Event {}
public protocol Action {}

/// State machine to handle a unidirectional data flow of event and actions.
public final class EventCoordinator<E: Event, S: State, A: Action> {

    /// Convenience alias for CoordinatorSystem.Event
    public typealias Event = E

    /// Convenience alias for CoordinatorSystem.State
    public typealias State = S

    /// Convenience alias for CoordinatorSystem.Action
    public typealias Action = A
    
    public typealias Update = (State, [Action], PassthroughSubject<Event, Never>)

    /// Current state of the EventCoordinator.
    
    public let events = PassthroughSubject<Event, Never>()
    
    private let statePublisher: CurrentValueSubject<State, Never>
    private let actionPublisher = PassthroughSubject<Update, Never>()

    private var subscriptions = [AnyCancellable]()
    private let workQueue = DispatchQueue(label: "com.isaac.eventCoordinator")
    
    
    private var eventHandler: EventHandler<Event, State, Action>
    
    public var currentState: State {
        statePublisher.value
    }

    public var state: AnyPublisher<State, Never> {
        statePublisher
            .eraseToAnyPublisher()
    }
    
    public var updates: AnyPublisher<Update, Never> {
        actionPublisher
            .eraseToAnyPublisher()
    }

    /// Creates an `EventCoordinator` with the following parameters.
    /// - Parameter eventHandler: `EventHandler` implementation to coordinate events and actions on
    ///   - state: Initial state for the coordinator
    public init(_ eventHandler: EventHandler<Event, State, Action>, state: State) {
        self.eventHandler = eventHandler
        self.statePublisher = CurrentValueSubject<State, Never>(state)
        
        events
            .receive(on: workQueue)
            .handle(self.eventHandler, state: self.statePublisher)
            .sink { [weak self] state, action in
                guard let self = self else { return }
                self.statePublisher.send(state)
                self.actionPublisher.send((state, action, self.events))
            }
            .store(in: &subscriptions)
    }
}

extension Publisher where Output: Event, Failure == Never {
    
    func handle<E: Event, S: State, A: Action>(
        _ handler: EventHandler<E, S, A>,
        state: CurrentValueSubject<S, Never>) -> AnyPublisher<(S, [A]), Never>
    {
        self.compactMap { $0 as? E }
            .map { event in
                var state = state.value
                let actions = handler.handle(event: event, state: &state)
                return (state, actions)
            }
            .eraseToAnyPublisher()
    }
}
