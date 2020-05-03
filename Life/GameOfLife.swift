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
        case evolve
        case randomize
    }
    
    struct State: Cooridnator.State {
        typealias Size = (width: Int, height: Int)

        let gridSize: Size
        
        var generation: Int = 0
        var nodes: [Bool]
        
        init(width: Int, height: Int, nodes: [Int]? = nil) {
            self.gridSize = (width: width, height: height)
            self.nodes = nodes?.map { $0 >= 1 ? true : false }
                         ?? [Bool].init(repeating: false, count: width * height)
        }
        
        struct Cell {
            let point: (x: Int, y: Int)
            var status: Status
            enum Status {
                case alive
                case dead
            }
        }
        
    }
    
    enum Action: Cooridnator.Action {
        
    }
}

struct GameOfLifeEventHandler: EventHandler {
    
    @discardableResult
    func handle(event: GameOfLife.Event, state: inout GameOfLife.State) -> [GameOfLife.Action] {
        
        switch event {
        case .evolve:
            let oldState = state.nodes
            state.nodes.enumerated().forEach { offset, element in
                
                var neighbors = [
                    offset + state.gridSize.width,
                    offset - state.gridSize.width]
                
                if (state.gridSize.width - offset) % state.gridSize.width != 0 {
                    neighbors += [
                        offset - 1,
                        offset - 1 - state.gridSize.width,
                        offset - 1 + state.gridSize.width,
                    ]
                }
                
                
                if (offset + 1) % state.gridSize.width != 0 {
                    neighbors += [
                        offset + 1,
                        offset + 1 - state.gridSize.width,
                        offset + 1 + state.gridSize.width,
                    ]
                }
                
                
                let alive = neighbors
                    .compactMap { oldState[safe: $0] }
                    .filter { $0 == true }
                    .count
                
                switch element {
                case true where alive == 2 || alive == 3:
                    break
                case false where alive == 3:
                    state.nodes[offset] = true
                default:
                    state.nodes[offset] = false
                }
            }
        case .randomize:
            state.nodes = (0..<(state.gridSize.width * state.gridSize.height)).map { _ in Bool.random() }
        }
        
        return []
    }
}

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

extension Collection where Element == Bool {
    func aliveNeighbors(_ i: Int) {
        
    }
}
