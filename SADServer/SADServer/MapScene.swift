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
        drawGrid()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: -
    func drawGrid() {
        // TODO: add lines
        // TODO: add labels
    }
    
    func reset() {
        self.removeAllChildren()
        drawGrid()
    }
    
    func addRandomPoints(n: Int) {
        if (n > 0) {
            addPoint(getRandomPosition())

            delay(300) {
                self.addRandomPoints(n - 1)
            }
        }
    }
    
    func addPoint(RFData: RangefinderData) {
        // TODO: add point relative to current position
    }
    
    func addPoint(loc: CGPoint) {
        var color = NSColor(hex: Config.get("ptColor") as String)
        var size = CGSize(width: Config.get("ptSize") as Int,
            height: Config.get("ptSize") as Int)
        
        let point = SKSpriteNode(color: color, size: size)
        point.position = loc

        self.addChild(point)
    }

}
