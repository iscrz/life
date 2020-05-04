//
//  GameScene.swift
//  Life
//
//  Created by Work on 5/2/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import SpriteKit
import GameplayKit
import Cooridnator
import Combine

class GameOfLifeScene: SKScene {
    
    var subscriptions: Set<AnyCancellable> = []
    
    let coordinator: EventCoordinator<GameOfLifeEventHandler>
    let nodeSize: Int
    
    private var squares: [Cell] = []
    
    private var title: String = "aa"
    
    init(size: CGSize, nodeSize: Int, coordinator: EventCoordinator<GameOfLifeEventHandler>) {
        self.coordinator = coordinator
        self.nodeSize = nodeSize
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        
        let width = coordinator.currentState.gridSize.width
        let height = coordinator.currentState.gridSize.height
        
        
        let square = Cell(diameter: nodeSize)
        for y in 0..<height {
            for x in 0..<width {
                let square = square.copy() as! Cell
                square.position = CGPoint(x: x * nodeSize, y: y * -nodeSize)
                addChild(square)
                squares.append(square)
            }
        }
        
        coordinator.state
            .new(\.generation)
            .map { "Generation \($0)" }
            .receive(on: RunLoop.main)
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
        
        coordinator.state
            .enumerate(\.nodes)
            .receive(on: RunLoop.main)
            .sink { [weak self] offset, element in
                self?.squares[offset].alive = element
            }
            .store(in: &subscriptions)
        
        coordinator.events.send(.randomize)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        coordinator.events.send(.randomize)
        coordinator.notify(.tappedStartButton)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}

class Cell: SKShapeNode {
    override init() { super.init() }
    
    init(diameter: Int) {
        super.init()
        
        
        self.path = CGPath(
            ellipseIn: CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter)), transform: nil)
        self.fillColor = .white
        self.lineWidth = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var alive: Bool = true {
        willSet {
            if newValue != alive {
                run(SKAction.fadeAlpha(to: newValue ? 1.0: 0.0, duration: 1.0), withKey: "Fade")
            }
        }
    }

}

