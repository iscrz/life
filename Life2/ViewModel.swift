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
    
    private var subscriptions: Set<AnyCancellable> = []
    
    let width: Int
    let height: Int
    
    @Published var cellState: [CellState] = []

    init(coordinator: EventCoordinator<GameOfLifeEventHandler>) {
        self.width = coordinator.currentState.gridSize.width
        self.height = coordinator.currentState.gridSize.height

        coordinator.state
            .map(\.nodes)
            .removeDuplicates()
            .measureInterval(using: RunLoop.main)
            .sink { print("gen\($0)")}
            .store(in: &subscriptions)
        
//        coordinator.state
//            .new(\.generation)
//            .sink { print("gen\($0)")}
//            .store(in: &subscriptions)
        
        coordinator.state
            .map(\.nodes)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: \ViewModel.cellState, on: self)
            .store(in: &subscriptions)
        
        coordinator.events.send(.randomize)
        coordinator.events.send(.tappedStartButton(0.05))
    }
}

