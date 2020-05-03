import Foundation
import Combine


public protocol State {}
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
    
    public let event = PassthroughSubject<Event, Never>()
    
    private let statePublisher: CurrentValueSubject<State, Never>
    private let actionPublisher = PassthroughSubject<Update, Never>()

    private var subscriptions = [AnyCancellable]()
    private let workQueue = DispatchQueue(label: "com.isaac.eventCoordinator")
    private var eventHandler: EventHandler<Event, State, Action>
    

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
        
        event
            .receive(on: workQueue)
            .sink { [weak self] event in
                guard let self = self else { return }
                
                var state = self.statePublisher.value
                let actions = self.eventHandler.handle(event: event, state: &state)
                self.statePublisher.send(state)

                let update = Update(state: state, actions: actions, notify: self.event)
                self.actionPublisher.send(update)
            }
            .store(in: &subscriptions)
    }
}
