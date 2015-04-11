//
//  Motor.cpp
//  SAD
//
//  Created by Marquez, Richard A on 4/9/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#include "Motor.h"

Motor::Motor(int enablePin, int controlPin1, int controlPin2) {
    if (enablePin > 0 && controlPin1 > 0 && controlPin2 > 0) {
        this->enablePin = enablePin;
        this->controlPin1 = controlPin1;
        this->controlPin2 = controlPin2;
        
        // Configure H-bridge
        pinMode(enablePin, OUTPUT);
        pinMode(controlPin1, OUTPUT);
        pinMode(controlPin2, OUTPUT);
        
        stop();
    }
}

void Motor::stop() {
    digitalWrite(controlPin1, LOW);
    digitalWrite(controlPin2, LOW);
}

void Motor::setSpeed(int speed) {
    analogWrite(enablePin, speed);
}

void Motor::accelerate() {
    digitalWrite(controlPin1, HIGH);
    digitalWrite(controlPin2, LOW);
}

void Motor::reverse() {
    digitalWrite(controlPin1, LOW);
    digitalWrite(controlPin2, HIGH);
}

