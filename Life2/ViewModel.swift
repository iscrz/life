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
    @Published var time: [Cell] = []

    init(coordinator: EventCoordinator<GameOfLifeEventHandler>) {
        
        self.coordinator = coordinator
        
        self.width = coordinator.currentState.gridSize.width
        self.height = coordinator.currentState.gridSize.height

        coordinator.state
            .new(\.nodes)
            .measureInterval(using: RunLoop.main)
            .sink { print("gen\($0.timeInterval)")}
            //.store(in: &subscriptions)
        
        coordinator.state
            .new(\.nodes)
            .receive(on: RunLoop.main)
            .assign(to: \ViewModel.cellState, on: self)
            .store(in: &subscriptions)
        
        //coordinator.events.send(.randomize)
        coordinator.events.send(.tappedStartButton(0.05))
    }
    
    func notify(_ event: GameOfLife.Event) {
        self.coordinator.events.send(event)
    }
}

