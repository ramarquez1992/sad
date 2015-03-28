//
//  CommStation.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/28/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation

class Drone {
    var location: CGPoint = CGPoint(x: 0, y: 0)
    var heading:  Int     = 0                       // North is 0 degrees
    var moving:   Bool    = false
    
    init() {
        //
    }
    
    func moveForward(distance: Int) {
        //
    }
    
    func turnRight(degrees: Int) {
        //
    }
    
    func sendCmd(cmd: String) {
        //comm.sendStr(cmd)
    }
}
