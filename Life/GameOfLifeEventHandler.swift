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

enum CellState: Equatable {
    case alive, dead
    var isAlive: Bool { self == .alive}
    static func random() -> CellState { Bool.random() ? .alive : .dead }
}

enum GameOfLife {
    
    enum Event: Cooridnator.Event {
        case tappedStartButton(TimeInterval)
        case evolve
        case randomize
        case tappedCellAt(Int)
    }
    
    struct State: Cooridnator.State {
        typealias GridSize = (width: Int, height: Int)

        let gridSize: GridSize
        
        var generation: Int = 0
        var nodes: [CellState]
        
        init(width: Int, height: Int, nodes: [Int]? = nil) {
            self.gridSize = (width: width, height: height)
            self.nodes = nodes?.map { $0 >= 1 ? .alive : .dead }
                ?? [CellState].init(repeating: .dead, count: width * height)
        }
    }
    
    enum Action: Cooridnator.Action {
        case start(TimeInterval)
        case stop
    }
}

struct GameOfLifeEventHandler: EventHandler {
    
    @discardableResult
    func handle(event: GameOfLife.Event, state: inout GameOfLife.State) -> [GameOfLife.Action] {
        var actions: [GameOfLife.Action] = []
        
        switch event {
        case let .tappedStartButton(interval):
            actions.append(.start(interval))
            
        case .evolve:
            let oldState = state
            state.nodes.enumerated().forEach { offset, element in
                
                let alive = oldState.aliveNeighbors(offset)
                
                switch element {
                case .alive where alive == 2 || alive == 3: break
                case .dead  where alive == 3: state.nodes[offset] = .alive
                default: state.nodes[offset] = .dead
                }
            }
            
            if state.nodes != oldState.nodes {
                state.generation += 1
            }
            
        case .randomize:
            state.nodes = (0..<(state.gridSize.width * state.gridSize.height)).map { _ in CellState.random() }
            
        case let .tappedCellAt(index):
            
            let cells = state.neighbors(for: index) + [index]
            cells.forEach { index in
                state.nodes[index] = CellState.random()
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
            index + gridSize.width, //bottom
            index - gridSize.width] // top
        
        if (gridSize.width - index) % gridSize.width != 0 {
            neighbors += [
                index - 1, // left
                index - 1 - gridSize.width, // top left
                index - 1 + gridSize.width, // bottom left
            ]
        }
        
        if (index + 1) % gridSize.width != 0 {
            neighbors += [
                index + 1, // right
                index + 1 - gridSize.width, // top right
                index + 1 + gridSize.width, // bottom right
            ]
        }
        
        return neighbors
    }
    
    fileprivate func aliveNeighbors(_ index: Int) -> Int {
        return neighbors(for: index)
            .compactMap { nodes[safe: $0] }
            .filter { $0.isAlive }
            .count
    }
}
