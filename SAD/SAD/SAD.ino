//
//  SAD.ino
//  SAD
//
//  Created by Marquez, Richard A on 4/9/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#include "main.h"

void setup() {
    // init here
}

void loop() {
    CommStation comm = CommStation::getInstance();
    
    if (comm.isAvailable()) {
        Drone drone = Drone::getInstance();
        
        if (drone.isBusy()) {
            comm.sendPacket(drone.scan());
        } else {
            Command cmd = comm.getCmd();
            drone.executeCmd(cmd);
        }
    }
}
