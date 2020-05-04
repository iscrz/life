#  <#Title#>

```swift
coordinator.state
    .map(\.nodes)
    .removeDuplicates()
    .flatMap { $0.enumerated().publisher }
    .sink {
        self.squares[$0.offset].fillColor = $0.element ? .blue : .yellow
    }
    .store(in: &subscriptions)
```

# Quirks
    - coordinator events are received in a different Queue so anything that subscribes to them in the same thread wont get updates right away
