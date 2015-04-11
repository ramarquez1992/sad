//
//  Drone.cpp
//  SAD
//
//  Created by Marquez, Richard A on 4/11/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#include "Drone.h"

Drone& Drone::getInstance() {
    static Drone instance;
    return instance;
}

Drone::Drone() {
    // Initialize motors
    int initialSpeed = 255;
    
    rMotor = Motor(H_ENABLE_PIN_1, H_CONTROL_PIN_1A, H_CONTROL_PIN_1B);
    rMotor.setSpeed(initialSpeed);
    
    lMotor = Motor(H_ENABLE_PIN_2, H_CONTROL_PIN_2A, H_CONTROL_PIN_2B);
    lMotor.setSpeed(initialSpeed);
    
    // Initialize rangefinders
    fRangefinder = Rangefinder(FRONT_RF_TRIG_PIN, FRONT_RF_ECHO_PIN, 0);
    //rRangefinder = new Rangefinder(RIGHT_RF_TRIG_PIN, RIGHT_RF_ECHO_PIN, 90);
    //lRangefinder = new Rangefinder(LEFT_RF_TRIG_PIN, LEFT_RF_ECHO_PIN, 270);
    
    compass = DigitalCompass();
}

bool Drone::isBusy() {
    return busy;
}

Packet Drone::scan() {
    int heading = compass.getHeading();
    
    int totalScans = 10; // 1ms total time
    vector<Range> RFData;
    
    RFData.push_back(fRangefinder.avgPing(totalScans));
    //RFData.push_back(lRangefinder->avgPing(totalScans));
    //RFData.push_back(rRangefinder->avgPing(totalScans));
    
    return Packet(heading, RFData);
}


void Drone::executeCmd(Command cmd) {
    switch (cmd.code) {
        // Move
        case 'f':
            moveForward();
            break;
            
        case 'b':
            moveBackward();
            break;
            
        // Turn
        case 'r':
            turnRight();
            break;
            
        case 'l':
            turnLeft();
            break;
            
        // Turn off motor
        case ' ':
            brake();
            break;
            
        // Unrecognized command
        default:
            ;//sendString("UNRECOGNIZED COMMAND\n");
    }
}

// MARK: - Movement
void Drone::brake() {
    rMotor.stop();
    lMotor.stop();
}

void Drone::moveForward() {
    rMotor.accelerate();
    lMotor.accelerate();
}

void Drone::moveBackward() {
    rMotor.reverse();
    lMotor.reverse();
}

void Drone::turnRight() {
    rMotor.reverse();
    lMotor.accelerate();
}

void Drone::turnLeft() {
    rMotor.accelerate();
    lMotor.reverse();
}
