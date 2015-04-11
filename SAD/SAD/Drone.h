//
//  Drone.h
//  SAD
//
//  Created by Marquez, Richard A on 4/11/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#pragma once

#include "Packet.h"
#include "Command.h"
#include "Motor.h"
#include "Rangefinder.h"
#include "DigitalCompass.h"

// Right motor
#define H_ENABLE_PIN_1   3
#define H_CONTROL_PIN_1A 2
#define H_CONTROL_PIN_1B 1

// Left motor
#define H_ENABLE_PIN_2   6
#define H_CONTROL_PIN_2A 4
#define H_CONTROL_PIN_2B 5

// Rangefinders (SunFounder HC-SR04)
#define FRONT_RF_TRIG_PIN A0
#define FRONT_RF_ECHO_PIN A1
#define RIGHT_RF_TRIG_PIN A2
#define RIGHT_RF_ECHO_PIN A3
#define LEFT_RF_TRIG_PIN  A4
#define LEFT_RF_ECHO_PIN  A5

class Drone {
private:
    bool busy = false;
    Motor rMotor;
    Motor lMotor;
    Rangefinder fRangefinder;
    Rangefinder rRangefinder;
    Rangefinder lRangefinder;
    DigitalCompass compass;
    
public:
    Drone();
    static Drone& getInstance();
    void executeCmd(Command cmd);
    bool isBusy();
    Packet scan();
    void brake();
    void moveForward();
    void moveBackward();
    void turnRight();
    void turnLeft();
};
