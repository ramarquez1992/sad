//
//  MapScene.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/28/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation
import SpriteKit

class MapScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        start()
    }
    
    func start() {
        println("starting")
    }

    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
