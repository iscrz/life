import Foundation
import Combine


public protocol Event {}
public protocol Action {}

/// State machine to handle a unidirectional data flow of event and actions.
public final class EventCoordinator<Handler: EventHandler> {

    /// Convenience alias for CoordinatorSystem.Event
    public typealias Event = Handler.E

    /// Convenience alias for CoordinatorSystem.State
    public typealias State = Handler.S

    /// Convenience alias for CoordinatorSystem.Action
    public typealias Action = Handler.A
    
    
    public typealias Update = (Action, State, PassthroughSubject<Event, Never>)
    
    public typealias UpdatePublisher = AnyPublisher<Update, Never>
    public typealias EventPublisher = PassthroughSubject<Event, Never>

    /// Current state of the EventCoordinator.
    
    public let events = EventPublisher()
    
    private let statePublisher: CurrentValueSubject<State, Never>
    private let actionPublisher = PassthroughSubject<[Action], Never>()

    private var subscriptions = [AnyCancellable]()
    private let workQueue = DispatchQueue(label: "com.isaac.eventCoordinator")
    
    private var eventHandler: Handler
    
    public var currentState: State {
        statePublisher.value
    }

    public lazy var state: AnyPublisher<State, Never> = {
        statePublisher
            .eraseToAnyPublisher()
    }()

    public lazy var updates: UpdatePublisher = {
        actionPublisher
            .receive(on: workQueue)
            .flatMap { $0.publisher }
            .zip(state, Just(self.events))
            .eraseToAnyPublisher()
    }()
    

    /// Creates an `EventCoordinator` with the following parameters.
    /// - Parameter eventHandler: `EventHandler` implementation to coordinate events and actions on
    ///   - state: Initial state for the coordinator
    public init(_ eventHandler: Handler, state: State) {
        self.eventHandler = eventHandler
        self.statePublisher = CurrentValueSubject<State, Never>(state)
        
        events
            .receive(on: workQueue)
            .handle(self.eventHandler, state: self.statePublisher) // map the event to a new state + action
            .sink { [weak self] state, actions in
                guard let self = self else { return }
                self.statePublisher.send(state)
                self.actionPublisher.send(actions)
            }
            .store(in: &subscriptions)
    }
    
    public func notify(_ event: Event) {
        events.send(event)
    }
}

extension Publisher where Output: Event, Failure == Never {
    
    func handle<Handler: EventHandler>(
        _ handler: Handler,
        state: CurrentValueSubject<Handler.S, Never>) -> AnyPublisher<(Handler.S, [Handler.A]), Never>
    {
        self.compactMap { $0 as? Handler.E }
            .map { event in
                var state = state.value
                let actions = handler.handle(event: event, state: &state)
                return (state, actions)
            }
            .eraseToAnyPublisher()
    }
}
