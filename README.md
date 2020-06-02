# Event Coordinator Pattern

## Events, States & Actions

- Events outline of all the possible events that might update the state
- State describes the current state of the application
- Actions outline all the possible async operations that might occur

## EventHandler
- Pure function that takes an `Event` and a `State`
- Mutates the `state` based on the given event
- Outputs the new state along with any async actions that need to be done

## EventCoordinator
- Wraps all of the above into a system in which you can manipluate a state and subscribe to any updates

# View Stack

## View Model

- Retains the Coordinator
- Subscribes to State Changes
- Maps state changes to local properties

```swift
coordinator.state
    .new(\.generation)
    .map { "Generation #\($0)"}
    .receive(on: RunLoop.main)
    .assign(to: \GameOfLifeViewModel.generationString, on: self)
    .store(in: &subscriptions)
```

## View

- Retains the ViewModel
- Send UI Events to the coordinator by way of the VM
- Subscribes to the _view model's_ display friendly properties


## Publisher Extensions

```swift
extension Publisher where Output: State, Failure == Never {
    
    /// Checks duplicates on the value of the keypath and returns a new publisher
    public func new<T: Equatable>(_ keyPath: KeyPath<Self.Output, T>) -> AnyPublisher<T, Never> {
        self.map(keyPath)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// Checks for duplicates on the value of an array at keypath and returns a stream of publishers.
    public func enumerate<T, E>(_ keyPath: KeyPath<Self.Output, T>)
        -> AnyPublisher<(offset: Int, element: E), Never>
        where T: Collection, T: Equatable, E == T.Element
        {
        
        self.map(keyPath)
            .removeDuplicates()
            .flatMap { $0.enumerated().publisher }
            .eraseToAnyPublisher()
    }
}
```
