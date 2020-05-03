import Foundation

public protocol EventHandler {
    
    associatedtype E: Event
    associatedtype S: State
    associatedtype A: Action

    func handle(event: E, state: inout S) -> [A]
}


