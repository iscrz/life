//
//  ViewModel.swift
//  Life2
//
//  Created by Work on 5/5/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import Combine
import Cooridnator

class GameOfLifeViewModel: ObservableObject {
    
    private var coordinator: EventCoordinator<GameOfLifeEventHandler>
    private var subscriptions: Set<AnyCancellable> = []
    
    let width: Int
    let height: Int
    
    @Published var cellState: [Cell] = []
    @Published var detlaString: String = ""
    @Published var generationString: String = ""

    init(coordinator: EventCoordinator<GameOfLifeEventHandler>) {
        
        self.coordinator = coordinator
        
        self.width = coordinator.currentState.gridSize.width
        self.height = coordinator.currentState.gridSize.height

        setupSubscriptions()
        
        coordinator.events.send(.randomize)
        coordinator.events.send(.tappedStartButton(0.05))
    }
    
    func setupSubscriptions() {
      
        // Updates cells if node array changes
        coordinator.state
            .new(\.nodes)
            .receive(on: RunLoop.main)
            .assign(to: \GameOfLifeViewModel.cellState, on: self)
            .store(in: &subscriptions)
        
        // Updates the Generation String when updated
        coordinator.state
            .new(\.generation)
            .map { "Generation #\($0)"}
            .receive(on: RunLoop.main)
            .assign(to: \GameOfLifeViewModel.generationString, on: self)
            .store(in: &subscriptions)
        
    }
    
    func notify(_ event: GameOfLife.Event) {
        self.coordinator.events.send(event)
    }
}

