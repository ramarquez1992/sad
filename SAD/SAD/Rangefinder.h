//
//  Rangefinder.h
//  SAD
//
//  Created by Marquez, Richard A on 4/9/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

/* HC-SR04 Sensor
 https://www.dealextreme.com/p/hc-sr04-ultrasonic-sensor-distance-measuring-module-133696
 
 This sketch reads a HC-SR04 ultrasonic rangefinder and returns the
 distance to the closest object in range. To do this, it sends a pulse
 to the sensor to initiate a reading, then listens for a pulse
 to return.  The length of the returning pulse is proportional to
 the distance of the object from the sensor.
 
 The circuit:
	* VCC attached to +5V
	* GND attached to ground
	* TRIG sends pulse
	* ECHO reads pulse
 */

#pragma once

#include <Arduino.h>
#include <StandardCplusplus.h>
#include <vector>
#include <numeric>
#include <algorithm>

using namespace std;

#define PING_AVG_CNT 10 // 1ms total ping time

class Range {
public:
    int centimeters;
    int angle;

    Range(int centimeters = 0, int angle = 0);
};

class Rangefinder {
private:
    int trigPin;
    int echoPin;
    int angle;

    int getMicroseconds();
    int getCentimeters();
    int getInches();
    int getAngle();
  
public:
    Rangefinder(int trigPin = -1, int echoPin = -1, int angle = 0);

    Range avgPing(int total);
    Range rawPing();
    void setAngle(int angle);
};
