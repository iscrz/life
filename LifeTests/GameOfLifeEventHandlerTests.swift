//
//  LifeTests.swift
//  LifeTests
//
//  Created by Work on 5/2/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import XCTest
@testable import Life

class GameOfLifeEventHandlerTests: XCTestCase {

    func testAllDead() {
    
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            width: 3, height: 3,
            nodes:
                [ 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.asBinary(),
        [
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
        ])
    }
    
    func testCenterColumn() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            width: 3, height: 3,
            nodes:
                [ 0, 1, 0,
                  0, 1, 0,
                  0, 1, 0, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.asBinary(),
        [
            0, 0, 0,
            1, 1, 1,
            0, 0, 0,
        ])
    }
    
    func testTopRow() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            width: 3, height: 3,
            nodes:
                [ 1, 1, 1,
                  0, 0, 0,
                  0, 0, 0, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.asBinary(),
        [
            0, 1, 0,
            0, 1, 0,
            0, 0, 0,
        ])
    }
    
    func testBottomRow() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            width: 3, height: 3,
            nodes:
                [ 0, 0, 0,
                  0, 0, 0,
                  1, 1, 1, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.asBinary(),
        [
            0, 0, 0,
            0, 1, 0,
            0, 1, 0,
        ])
    }
    
    func testLeftSide() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            width: 3, height: 3,
            nodes:
                [ 1, 0, 0,
                  1, 0, 0,
                  1, 0, 0, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.asBinary(),
        [
            0, 0, 0,
            1, 1, 0,
            0, 0, 0,
        ])
    }
    
    func testRightSide() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            width: 3, height: 3,
            nodes:
                [ 0, 0, 1,
                  0, 0, 1,
                  0, 0, 1, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.asBinary(),
        [
            0, 0, 0,
            0, 1, 1,
            0, 0, 0,
        ])
    }
    
    func testEitherSide() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            width: 3, height: 3,
            nodes:
                [ 1, 0, 1,
                  1, 0, 1,
                  1, 0, 1, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.asBinary(),
        [
            0, 0, 0,
            1, 0, 1,
            0, 0, 0,
        ])
    }
    
    func testTopBottom() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            width: 3, height: 3,
            nodes:
                [ 1, 1, 1,
                  0, 0, 0,
                  1, 1, 1, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.asBinary(),
        [
            0, 1, 0,
            0, 0, 0,
            0, 1, 0,
        ])
    }
    
    func testStableSquare() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            width: 4, height: 4,
            nodes:
                [ 0, 0, 0, 0,
                  0, 1, 1, 0,
                  0, 1, 1, 0,
                  0, 0, 0, 0,])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.asBinary(),
        [
            0, 0, 0, 0,
            0, 1, 1, 0,
            0, 1, 1, 0,
            0, 0, 0, 0,])
    }

}

extension Array where Element == Cell {
    func asBinary() -> [Int] {
        return map { $0.isAlive ? 1 : 0 }
    }
}
