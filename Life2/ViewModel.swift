//
//  ViewModel.swift
//  Life2
//
//  Created by Work on 5/5/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import Combine
import Cooridnator

class ViewModel: ObservableObject {
    
    private var coordinator: EventCoordinator<GameOfLifeEventHandler>
    private var subscriptions: Set<AnyCancellable> = []
    
    let width: Int
    let height: Int
    
    @Published var cellState: [Cell] = []
    @Published var detlaString: String = ""

    init(coordinator: EventCoordinator<GameOfLifeEventHandler>) {
        
        self.coordinator = coordinator
        
        self.width = coordinator.currentState.gridSize.width
        self.height = coordinator.currentState.gridSize.height

        setupSubscriptions()
        
        coordinator.events.send(.randomize)
        coordinator.events.send(.tappedStartButton(0.05))
    }
    
    func setupSubscriptions() {
        
        // Display the time between new state events
        coordinator.state
            .measureInterval(using: RunLoop.main)
            .combineLatest(coordinator.state)
            .map { (stride, state) -> String in
                let delta = state.timeInterval - stride.timeInterval
                let nf = NumberFormatter()
                nf.maximumFractionDigits = 4
                return "\(abs(delta) < 0.2 ? "👍" : "👎") \(nf.string(for: delta) ?? "")"
            }
            .receive(on: RunLoop.main)
            .assign(to: \.detlaString, on: self)
            .store(in: &subscriptions)
        
        // Updates cells if node array changes
        coordinator.state
            .new(\.nodes)
            .receive(on: RunLoop.main)
            .assign(to: \ViewModel.cellState, on: self)
            .store(in: &subscriptions)
    }
    
    func notify(_ event: GameOfLife.Event) {
        self.coordinator.events.send(event)
    }
}

