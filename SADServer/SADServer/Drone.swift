//
//  CommStation.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/28/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation

class Drone {
    
    let comm = Comm.getInstance()
    
    var location: CGPoint = CGPoint(x: 0, y: 0)
    var heading: Int = Compass.NORTH
    var moving: Bool = false
    
    init() {
        //
    }
    
    func moveForward(distance: Int) {
        // TODO:
    }
    
    func turnRight(degrees: Int) {
        // TODO:
    }
    
}
