//
//  ViewModel.swift
//  Life
//
//  Created by Work on 5/4/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import UIKit
import Combine
import Cooridnator

class ViewModel {
    
    var subscriptions: Set<AnyCancellable> = []
    let coordinator: EventCoordinator<GameOfLifeEventHandler>
    
    init(coordinator: EventCoordinator<GameOfLifeEventHandler>) {
        self.coordinator = coordinator
    }
    
    func notify(_ event: GameOfLife.Event) {
        self.coordinator.events.send(event)
    }
    
    var gridSize: GameOfLife.State.GridSize {
        coordinator.currentState.gridSize
    }
    
    lazy var generationString: AnyPublisher<String, Never> = {
        coordinator.state
            .new(\.generation) // ignores duplicates
            .map { "Generation \($0)" }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }()
    
    lazy var cellStates: AnyPublisher<(offset: Int, element: CellState), Never> = {
        coordinator.state
            .enumerate(\.nodes) // ignores duplicates
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }()
}
