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
    
    let viewModel: ViewModel
    let nodeSize: Int
    
    private var cells: [CellView] = []
    
    private var title: String = "aa"
    
    init(size: CGSize, nodeSize: Int, coordinator: EventCoordinator<GameOfLifeEventHandler>) {
        self.viewModel = ViewModel(coordinator: coordinator)
        self.nodeSize = nodeSize
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        setupView()
        setupSubscriptions()
    }
    
    func setupView() {
        
       
        
        let width = viewModel.gridSize.width
        let height = viewModel.gridSize.height
        
        let square = CellView(diameter: nodeSize)
        for y in 0..<height {
            for x in 0..<width {
                let square = square.copy() as! CellView
                square.position = CGPoint(x: x * nodeSize, y: y * -nodeSize)
                addChild(square)
                cells.append(square)
            }
        }
        
        let titleView = SKLabelNode(fontNamed: "Helventica")
               titleView.fontSize = 50
               titleView.text = "asdf"
               titleView.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
               addChild(titleView)
    }
    
    func setupSubscriptions() {
        
        // Subscribe to Title Changes
        viewModel.$generationString
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
        
    
        // Subscribe to Cell Changes
        viewModel.$cellStates
            .sink { [weak self] foo in
                
                //index.
                //self?.cells[offset].state = element
            }
            .store(in: &subscriptions)
    }
    
    
    // MARK - Touch Stuff
    
    func touchDown(atPoint pos : CGPoint) {
        let index = cellIndex(at: pos)
        viewModel.notify(.tappedCellAt(index))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func cellIndex(at pos: CGPoint) -> Int {
        let gridSize = CGSize(width: viewModel.gridSize.width, height: viewModel.gridSize.height)
        let x = Int(round((pos.x / size.width) * CGFloat(gridSize.width)))
        let y = Int(round((pos.y / size.height) * CGFloat(gridSize.height)))
        let index = (-y * Int(gridSize.width)) + x
        return index
    }
}
