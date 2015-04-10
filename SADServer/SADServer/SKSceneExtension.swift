//
//  SKSceneExtension.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 12/22/14.
//  Copyright (c) 2014 Richard Marquez. All rights reserved.
//

import SpriteKit

extension SKScene {
    
    func getRandomPosition() -> CGPoint {
        let x = CGFloat(size.width) * (CGFloat(arc4random()) / CGFloat(UInt32.max))
        let y = CGFloat(size.height) * (CGFloat(arc4random()) / CGFloat(UInt32.max))
        
        return CGPoint(x: x, y: y)
    }
    
    func getRelativeDirection(origin: CGPoint, destination: CGPoint) -> CGPoint {
        let facingDirection = (destination - origin).normalized()
        
        return facingDirection
    }
    
}
