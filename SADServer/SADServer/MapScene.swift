//
//  MapScene.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/28/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import SpriteKit

class MapScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        addRandomPoints()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: -
    func addRandomPoints() {
        addPoint(getRandomPosition())
        
        delay(1) {
            self.addRandomPoints()
        }
    }
    
    func addPoint(RFData: RangefinderData) {
        // TODO:
    }
    
    func addPoint(loc: CGPoint) {
        var color = NSColor(hex: "00ff00")
        var size = CGSize(width: 5, height: 5)
        
        let point = SKSpriteNode(color: color, size: size)
        point.position = loc
        
        self.addChild(point)
    }

}
