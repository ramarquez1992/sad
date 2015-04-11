//
//  DigitalCompass.cpp
//  SAD
//
//  Created by Marquez, Richard A on 4/11/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#include "DigitalCompass.h"

DigitalCompass::DigitalCompass() {
    Wire.begin();
    setScale(1.3);
    setMeasurementMode(MEASUREMENT_CONTINUOUS);
}

float DigitalCompass::getHeading() {
    // Takes ~10ms
    MagnetometerScaled scaled = readScaledAxis();
    float rawHeading = atan2(scaled.YAxis, scaled.XAxis) + DECLINATION_ANGLE;
    
    // Correct for when signs are reversed.
    if (rawHeading < 0)
        rawHeading += 2*PI;
    
    // Check for wrap due to addition of declination.
    if (rawHeading > 2*PI)
        rawHeading -= 2*PI;
    
    // Convert radians to degrees
    rawHeading = rawHeading * 180/M_PI;
    
    if (rawHeading >= 360)
        rawHeading -= 360;
    else if (rawHeading < 0)
        rawHeading += 360;
    
    heading = rawHeading;
    
    return heading;
}

