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
    
    @Published private(set) var generationString: String = ""
    @Published private(set) var cellStates: [CellState] = []
    
    var subs = Set<AnyCancellable>()
    
    var subscriptions: Set<AnyCancellable> = []
    let coordinator: EventCoordinator<GameOfLifeEventHandler>
    
    init(coordinator: EventCoordinator<GameOfLifeEventHandler>) {
        self.coordinator = coordinator
        
        coordinator.state
            .new(\.generation)
            .map { "Generation \($0)" }
            .receive(on: RunLoop.main)
            .assign(to: \.generationString, on: self)
            .store(in: &subs)
        
        coordinator.state
            .new(\.nodes)
            .receive(on: RunLoop.main)
            .assign(to: \.cellStates, on: self)
            .store(in: &subs)
    }
    
    func notify(_ event: GameOfLife.Event) {
        self.coordinator.events.send(event)
    }
    
    var gridSize: GameOfLife.State.GridSize {
        coordinator.currentState.gridSize
    }
}
