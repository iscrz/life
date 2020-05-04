import Foundation
import Combine


public protocol Event {}
public protocol Action {}

/// State machine to handle a unidirectional data flow of event and actions.
public final class EventCoordinator<Handler: EventHandler> {

    public typealias Event = Handler.E
    public typealias State = Handler.S
    public typealias Action = Handler.A
    
    
    public typealias Update = (Action, State, EventPublisher)
    
    public typealias UpdatePublisher = AnyPublisher<Update, Never>
    public typealias EventPublisher = PassthroughSubject<Event, Never>

    
    public let events = EventPublisher()
    private let statePublisher: CurrentValueSubject<State, Never>
    private let actionPublisher = PassthroughSubject<[Action], Never>()

    private var subscriptions = [AnyCancellable]()
    private let workQueue = DispatchQueue(label: "eventCoordinator")
    private var eventHandler: Handler
    
    
    public var currentState: State {
        statePublisher.value
    }

    /// Read-Only publisher of states
    public lazy var state: AnyPublisher<State, Never> = {
        statePublisher
            .eraseToAnyPublisher()
    }()

    /// Converts an array of [Action] into a stream of Actions with state and the event publisher attached
    public lazy var updates: UpdatePublisher = {
        actionPublisher
            .receive(on: workQueue)
            .flatMap { $0.publisher }
            .zip(state, Just(self.events))
            .eraseToAnyPublisher()
    }()
    

    public init(_ eventHandler: Handler, state: State) {
        self.eventHandler = eventHandler
        self.statePublisher = CurrentValueSubject<State, Never>(state)
        
        events
            .receive(on: workQueue)
            .handle(self.eventHandler, state: self.statePublisher)
            .sink { [weak self] state, actions in
                guard let self = self else { return }
                self.statePublisher.send(state)
                self.actionPublisher.send(actions)
            }
            .store(in: &subscriptions)
    }
}

extension Publisher where Output: Event, Failure == Never {
    
    /// Maps an upstream event into a new state + actions, given an `Event Handler`
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
