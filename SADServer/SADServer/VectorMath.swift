//
//  Physics.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/28/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation

enum Heading: Int {
    case North = 0
    case East
    case South
    case West
}

func RADIANS_TO_DEGREES(radians: CGFloat) -> CGFloat {
    return CGFloat((Double(radians) / (2 * M_PI)) * 360)
}

func DEGREES_TO_RADIANS(degrees: CGFloat) -> CGFloat {
    return CGFloat((Double(degrees) / 360) * (2 * M_PI))
}

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

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    // Turn into a unit vector (magnitude 1) that is easy to scale
    func normalized() -> CGPoint {
        return self / length()
    }
}


