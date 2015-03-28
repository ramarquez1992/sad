//
//  SKSceneExtension.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 12/22/14.
//  Copyright (c) 2014 Richard Marquez. All rights reserved.
//

import SpriteKit

extension SKScene {
    func getRandomPosition(fromPoint: CGPoint = CGPoint(), minDistance: CGFloat = 0.0) -> CGPoint {
        var possiblePosition: CGPoint
        var possibleLength: CGFloat
        var currentLength = fromPoint.length()
        var distance: CGFloat = 0.0
        
        do {
            possiblePosition = CGPoint(x: CGFloat(size.width) * (CGFloat(arc4random()) / CGFloat(UInt32.max)),
                y: CGFloat(size.height) * (CGFloat(arc4random()) / CGFloat(UInt32.max)))
            
            possibleLength = possiblePosition.length()
            distance = abs(currentLength - possibleLength)
        } while distance < CGFloat(minDistance)
        
        return possiblePosition
    }
    
    func getRelativeDirection(origin: CGPoint, destination: CGPoint) -> CGPoint {
        let facingDirection = (destination - origin).normalized()
        
        return facingDirection
    }
}