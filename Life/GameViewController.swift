//
//  GameViewController.swift
//  Life
//
//  Created by Work on 5/2/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Combine
import Cooridnator

class GameViewController: UIViewController {
    
    var lifeActionHandler: ActionHandler!
    var coordinator: EventCoordinator<GameOfLifeEventHandler>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = view.bounds.size
        let nodeSize: Int = 10
        
        let width = Int(ceil(size.width / CGFloat(nodeSize))) + 1
        let height = Int(ceil(size.height / CGFloat(nodeSize))) + 1
        
        let state = GameOfLife.State(width: width, height: height)
        coordinator = EventCoordinator(GameOfLifeEventHandler(), state: state)
        lifeActionHandler = ActionHandler(coordinator!.updates)
        
        let sceneNode = GameScene(size: size, nodeSize: nodeSize, coordinator: coordinator)
        sceneNode.scaleMode = .aspectFill
            
        // Present the scene
        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        return
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
