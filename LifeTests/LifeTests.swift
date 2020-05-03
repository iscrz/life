//
//  LifeTests.swift
//  LifeTests
//
//  Created by Work on 5/2/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import XCTest
@testable import Life

class LifeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testAllDead() {
    
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            height: 3,
            width: 3,
            nodes:
                [ 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.map { $0 == true ? 1 : 0 },
        [
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
        ])
    }
    
    func testCenterColumn() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            height: 3,
            width: 3,
            nodes:
                [ 0, 1, 0,
                  0, 1, 0,
                  0, 1, 0, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.map { $0 == true ? 1 : 0 },
        [
            0, 0, 0,
            1, 1, 1,
            0, 0, 0,
        ])
    }
    
    func testTopRow() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            height: 3,
            width: 3,
            nodes:
                [ 1, 1, 1,
                  0, 0, 0,
                  0, 0, 0, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.map { $0 == true ? 1 : 0 },
        [
            0, 1, 0,
            0, 1, 0,
            0, 0, 0,
        ])
    }
    
    func testBottomRow() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            height: 3,
            width: 3,
            nodes:
                [ 0, 0, 0,
                  0, 0, 0,
                  1, 1, 1, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.map { $0 == true ? 1 : 0 },
        [
            0, 0, 0,
            0, 1, 0,
            0, 1, 0,
        ])
    }
    
    func testLeftSide() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            height: 3,
            width: 3,
            nodes:
                [ 1, 0, 0,
                  1, 0, 0,
                  1, 0, 0, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.map { $0 == true ? 1 : 0 },
        [
            0, 0, 0,
            1, 1, 0,
            0, 0, 0,
        ])
    }
    
    func testRightSide() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            height: 3,
            width: 3,
            nodes:
                [ 0, 0, 1,
                  0, 0, 1,
                  0, 0, 1, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.map { $0 == true ? 1 : 0 },
        [
            0, 0, 0,
            0, 1, 1,
            0, 0, 0,
        ])
    }
    
    func testEitherSide() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            height: 3,
            width: 3,
            nodes:
                [ 1, 0, 1,
                  1, 0, 1,
                  1, 0, 1, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.map { $0 == true ? 1 : 0 },
        [
            0, 0, 0,
            1, 0, 1,
            0, 0, 0,
        ])
    }
    
    func testTopBottom() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            height: 3,
            width: 3,
            nodes:
                [ 1, 1, 1,
                  0, 0, 0,
                  1, 1, 1, ])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.map { $0 == true ? 1 : 0 },
        [
            0, 1, 0,
            0, 0, 0,
            0, 1, 0,
        ])
    }
    
    func testStableSquare() {
       
        let handler = GameOfLifeEventHandler()
        
        var state = GameOfLife.State(
            height: 4,
            width: 4,
            nodes:
                [ 0, 0, 0, 0,
                  0, 1, 1, 0,
                  0, 1, 1, 0,
                  0, 0, 0, 0,])
        
        handler.handle(event: .evolve, state: &state)
        
        XCTAssertEqual(state.nodes.map { $0 == true ? 1 : 0 },
        [
            0, 0, 0, 0,
            0, 1, 1, 0,
            0, 1, 1, 0,
            0, 0, 0, 0,])
    }

}
