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
        case tappedStartButton
        case evolve
        case randomize
        case tappedCellAt(Int)
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
        case start
        case stop
    }
}

struct GameOfLifeEventHandler: EventHandler {
    
    @discardableResult
    func handle(event: GameOfLife.Event, state: inout GameOfLife.State) -> [GameOfLife.Action] {
        var actions: [GameOfLife.Action] = []
        
        switch event {
        case .tappedStartButton:
            actions.append(.start)
        case .evolve:
            let oldState = state
            state.nodes.enumerated().forEach { offset, element in
                
                let alive = oldState.aliveNeighbors(offset)
                
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
            
        case let .tappedCellAt(index):
            
            let cells = state.neighbors(for: index) + [index]
            cells.forEach { index in
                state.nodes[index] = Bool.random()
            }
            
            
            break
        }
        
        return actions
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

extension GameOfLife.State {
    
    func neighbors(for index: Int) -> [Int] {
        var neighbors = [
            index + gridSize.width,
            index - gridSize.width]
        
        if (gridSize.width - index) % gridSize.width != 0 {
            neighbors += [
                index - 1,
                index - 1 - gridSize.width,
                index - 1 + gridSize.width,
            ]
        }
        
        
        if (index + 1) % gridSize.width != 0 {
            neighbors += [
                index + 1,
                index + 1 - gridSize.width,
                index + 1 + gridSize.width,
            ]
        }
        
        return neighbors
    }
    
    fileprivate func aliveNeighbors(_ index: Int) -> Int {
        return neighbors(for: index)
            .compactMap { nodes[safe: $0] }
            .filter { $0 == true }
            .count
    }
}

private struct Pattern {
    let size: CGFloat
    let pattern: [Int]
    
    var center: Int {
        Int(floor(size * size / 2.0))
    }
}
