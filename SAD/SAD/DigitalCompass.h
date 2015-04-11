//
//  DigitalCompass.h
//  SAD
//
//  Created by Marquez, Richard A on 4/11/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#pragma once

#include <StandardCplusplus.h>
#include <vector>
#include <numeric>
#include <algorithm>
#include <HMC5883L.h>

using namespace std;

#define DECLINATION_ANGLE 0.0    // in radians (Winona, MN)

class DigitalCompass : public HMC5883L {
private:
    float heading;
    
public:
    DigitalCompass();
    float getHeading();
};
