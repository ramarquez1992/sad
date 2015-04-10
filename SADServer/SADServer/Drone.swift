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
    var running = false
    var physicalPosition = CGPoint()

    var heading: CGFloat = Compass.NORTH {
        didSet {
            zRotation = degreesToRadians(heading) * -1
        }
    }
    
    init() {
        let spriteColor = NSColor(hex: Config.get("droneSpriteColor") as! String)
        let spriteSize = CGSize(width: (Config.get("droneSpriteSize") as! CGFloat) * (Config.get("droneSpriteRatio") as! CGFloat),
            height: Config.get("droneSpriteSize") as! CGFloat)
        
        super.init(texture: nil, color: spriteColor, size: spriteSize)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset(pos: CGPoint, physicalPos: CGPoint) {
        heading = Compass.NORTH
        running = false
        position = pos
        physicalPosition = physicalPos
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
