//
//  CooridnatorTests.swift
//  CooridnatorTests
//
//  Created by Work on 5/2/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import XCTest
import Combine
@testable import Cooridnator

class CooridnatorTests: XCTestCase {
    
    var subscriptions: [AnyCancellable]!

    override func setUp() {
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = []
    }

    func testCounting() {
        let expect = expectation(description: "Expecting it to work.")
        let coordinator = EventCoordinator(MockEventHandler(), state: .init())
        coordinator.state
            .print()
            .sink { state in
                if state.count == 3 {
                    expect.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        coordinator.events
            .sink {
                print("LOG: did send event: \($0)")
            }
            .store(in: &subscriptions)
        
        coordinator.events.send(.one)
        coordinator.events.send(.one)
        coordinator.events.send(.one)
        
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

enum MockSystem {
    enum Event: Cooridnator.Event {
        case one
    }
    
    struct State: Cooridnator.State {
        var count: Int = 0
    }
    
    enum Action: Cooridnator.Action {
        case two
    }
}

class MockEventHandler: EventHandler<MockSystem.Event, MockSystem.State, MockSystem.Action> {
    override func handle(event: MockSystem.Event, state: inout MockSystem.State) -> [MockSystem.Action] {
        
        switch event {
        case .one:
            state.count += 1
        }
        
        return []
    }
}
