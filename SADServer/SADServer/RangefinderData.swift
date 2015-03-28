//
//  RangefinderData.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/27/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation

class RangefinderData {
    var distance: Int
    var angle: Int
    
    init(distance: Int, angle: Int) {
        self.distance = distance
        self.angle = angle
    }
}