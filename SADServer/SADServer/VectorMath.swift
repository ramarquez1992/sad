//
//  Physics.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/28/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation

// MARK: - Conversions
func radiansToDegrees(radians: CGFloat) -> CGFloat {
    return CGFloat(Double(radians) * (180 / M_PI))
}

func degreesToRadians(degrees: CGFloat) -> CGFloat {
    return CGFloat(Double(degrees) * (M_PI / 180))
}

// MARK: - Operator overloads
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) ->CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

// MARK: -
func angleToUnitVector(angle: CGFloat) -> CGPoint {
    let unit = CGPoint(x: 0, y: 1)                  // Unit vector of 0deg
    let radians = degreesToRadians(angle * -1)      // Rotation takes counter-clockwise radians
    
    let newX = (unit.x * cos(radians)) - (unit.y * sin(radians))
    let newY = (unit.x * sin(radians)) + (unit.y * cos(radians))
    
    return CGPoint(x: newX, y: newY)
}

extension CGPoint {
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    // Turn into a unit vector (magnitude 1) that is easy to scale
    func normalized() -> CGPoint {
        return self / length()
    }
    
}
