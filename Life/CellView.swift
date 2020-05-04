//
//  CellView.swift
//  Life
//
//  Created by Work on 5/4/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import SpriteKit

class CellView: SKShapeNode {
    override init() { super.init() }
    
    init(diameter: Int) {
        super.init()
        
        
        self.path = CGPath(
            ellipseIn: CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter)), transform: nil)
        self.fillColor = .white
        self.lineWidth = 0
        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var state: CellState = .dead {
        willSet {
            if newValue != state {
                run(SKAction.fadeAlpha(to: newValue.isAlive ? 1.0: 0.0, duration: 1.0), withKey: "Fade")
            }
        }
    }

}

