//
//  GameOfLife.swift
//  Life
//
//  Created by Work on 5/2/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import Foundation
import CoreGraphics
import Cooridnator

enum GameOfLife {
    enum Event: Cooridnator.Event {
        case randomize
    }
    
    struct State: Cooridnator.State {
        let gridSize = (width: 10, height: 10)
        var generation: Int = 0
        var nodes: [Bool] = [true, false, true, true, true]
    }
    
    enum Action: Cooridnator.Action {
        
    }
}


class GameOfLifeEventHandler: EventHandler<GameOfLife.Event, GameOfLife.State, GameOfLife.Action> {
    override func handle(event: Event, state: inout State) -> [Action] {
        
        switch event {
        case .randomize:
            state.nodes = (0..<(state.gridSize.width * state.gridSize.height)).map { _ in Bool.random() }
        }
        
        return []
    }
}
