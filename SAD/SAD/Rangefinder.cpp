//
//  Rangefinder.cpp
//  SAD
//
//  Created by Marquez, Richard A on 4/9/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#include "Rangefinder.h"

Range::Range(int centimeters, int angle) {
    this->centimeters = centimeters;
    this->angle = angle;
}

Rangefinder::Rangefinder(int trigPin, int echoPin, int angle) {
    if (trigPin > 0 && echoPin > 0) {
        this->trigPin = trigPin;
        this->echoPin = echoPin;
        this->angle = angle;
        
        // Configure sensor
        pinMode(trigPin, OUTPUT);
        digitalWrite(trigPin, LOW);
    }
}

Range Rangefinder::rawPing() {
    return Range(getCentimeters(), getAngle());
}

int getMean(vector<int> set) {
    return accumulate(set.begin(), set.end(), 0) / set.size();
}

int getMedian(vector<int> set) {
    if (set.size() < 1) {
        return 0;
    } 

    sort(set.begin(), set.end());

    int median;
    int middle = set.size() / 2;

    if (set.size() % 2 == 0) {
        vector<int> middleSet;
        middleSet.push_back(set.at(middle));
        middleSet.push_back(set.at(middle - 1));

        median = getMean(middleSet);
    } else {
        median = set.at(middle);
    }

    return median;
}

int getAvg(vector<int> set) {
  return getMedian(set);
}

Range Rangefinder::avgPing(int total) {
    vector<int> ranges;

    for (int i = 0; i < total; ++i) {
        ranges.push_back(getInches());
    }

    return Range(getAvg(ranges), getAngle());
}

int Rangefinder::getMicroseconds() {
    int microseconds = NULL;

    // Ensure a clean HIGH pulse
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);

    // Send out trigger pulse
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    // Measure echo
    pinMode(echoPin, INPUT);
    microseconds = pulseIn(echoPin, HIGH);

    return microseconds;
}

int Rangefinder::getCentimeters() {
    // The speed of sound is 340 m/s or 29 microseconds per centimeter.
    // The ping travels out and back, so to find the distance of the
    // object we take half of the distance travelled.
    int centimeters = getMicroseconds() / 29 / 2;

    // Distance is unreliable past 8ft so report as unobstructed
    if (centimeters > 250 || centimeters < 0) {
        centimeters = NULL;
    }

    return centimeters;
}

int Rangefinder::getInches() {
    return getCentimeters() / 2.54;
}

int Rangefinder::getAngle() {
    return angle;
}

void Rangefinder::setAngle(int angle) {
    this->angle = angle;
}
