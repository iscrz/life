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

class GameScene: SKScene {
    
    var subscriptions: Set<AnyCancellable> = []
    
    let coordinator: EventCoordinator<GameOfLife.Event, GameOfLife.State, GameOfLife.Action> = {
        let state = GameOfLife.State(height: 10, width: 10, nodes:
        [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
            0, 0, 0, 1, 1, 1, 0, 0, 0, 1,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
            0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
            0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
            0, 0, 0, 1, 0, 1, 1, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        ])
        return EventCoordinator(GameOfLifeEventHandler(), state: state)
    }()
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var squares: [SKShapeNode] = []
    
    private var title: String = "aa"
    
    override func sceneDidLoad() {
        
        let size = coordinator.currentState.gridSize
        
        let square = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 30, height: 30))
        square.fillColor = .blue
        for y in 0..<size.height {
            for x in 0..<size.width {
                let square = square.copy() as! SKShapeNode
                square.position = CGPoint(x: -200 + (x * 40), y: y * -40)
                addChild(square)
                squares.append(square)
            }
        }
        
        coordinator.state
            .new(\.generation)
            .map { "Generation \($0)" }
            .print()
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
        
        coordinator.state
            .enumerate(\.nodes)
            .sink { [weak self] offset, element in
                //self?.squares[offset].fillColor = element ? .yellow : .blue
                self?.squares[offset].run(SKAction.fadeAlpha(to: element ? 1.0 : 0, duration: 0.25))
            }
            .store(in: &subscriptions)
        
        
        coordinator.events.send(.randomize)
        
        /* OLD WAY
        coordinator.state
            .map(\.nodes)
            .removeDuplicates()
            .flatMap { $0.enumerated().publisher }
            .sink {
                self.squares[$0.offset].fillColor = $0.element ? .blue : .yellow
            }
            .store(in: &subscriptions)
        */
        
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        coordinator.events.send(.evolve)
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
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
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
