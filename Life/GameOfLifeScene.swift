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
    
    private var cells: [CellView] = []
    
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
        setupView()
        setupCoordinator()
    }
    
    func setupView() {
        
        let width = coordinator.currentState.gridSize.width
        let height = coordinator.currentState.gridSize.height
        
        let square = CellView(diameter: nodeSize)
        for y in 0..<height {
            for x in 0..<width {
                let square = square.copy() as! CellView
                square.position = CGPoint(x: x * nodeSize, y: y * -nodeSize)
                addChild(square)
                cells.append(square)
            }
        }
    }
    
    func setupCoordinator() {
        
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
                self?.cells[offset].state = element
            }
            .store(in: &subscriptions)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let x = Int(round((pos.x / size.width) * CGFloat(coordinator.currentState.gridSize.width)))
        let y = Int(round((pos.y / size.height) * CGFloat(coordinator.currentState.gridSize.height)))
        let index = (-y * coordinator.currentState.gridSize.width) + x
        coordinator.notify(.tappedCellAt(index))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}

