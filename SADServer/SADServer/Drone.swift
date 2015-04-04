//
//  CommStation.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/28/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation
import SpriteKit

class Drone: SKSpriteNode {
    
    let comm = Comm.getInstance()
    
    var heading = Compass.NORTH
    var running = false
    
    override init() {
        var spriteColor = NSColor(hex: Config.get("droneSpriteColor") as String)
        var spriteSize = CGSize(width: (Config.get("droneSpriteSize") as CGFloat) * (Config.get("droneSpriteRatio") as CGFloat),
            height: Config.get("droneSpriteSize") as CGFloat)
        
        super.init(texture: nil, color: spriteColor, size: spriteSize)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset(loc: CGPoint) {
        heading = Compass.NORTH
        running = false
        position = loc
    }
    
    func startSLAM() {
        running = true
        
        comm.sendStr("f")
    }
    
    func stopSLAM() {
        running = false
        
        comm.sendStr(" ")
    }
}
