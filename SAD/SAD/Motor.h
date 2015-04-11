//
//  Motor.h
//  SAD
//
//  Created by Marquez, Richard A on 4/9/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#pragma once

#include <Arduino.h>

class Motor {
private:
    int enablePin;
    int controlPin1;
    int controlPin2;
  
public:
    Motor(int enablePin = -1, int controlPin1 = -1, int controlPin2 = -1);

    void stop();
    void setSpeed(int speed);
    void accelerate();
    void reverse();
};
