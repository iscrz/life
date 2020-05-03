//
//  GameOfLife.swift
//  Life
//
//  Created by Work on 5/2/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import Foundation
import Cooridnator

enum GameOfLife {
    enum Event: Cooridnator.Event {
        case randomize
    }
    
    struct State: Cooridnator.State {
        var generation: Int = 0
        var nodes: [Bool] = []
    }
    
    enum Action: Cooridnator.Action {
        
    }
}


class GameOfLifeEventHandler: EventHandler<GameOfLife.Event, GameOfLife.State, GameOfLife.Action> {
    override func handle(event: Event, state: inout State) -> [Action] {
        
        switch event {
        case .randomize:
            state.nodes = (0...10).map { _ in Bool.random() }
        }
        
        return []
    }
}
