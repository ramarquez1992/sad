//
//  Packet.h
//  SAD
//
//  Created by Marquez, Richard A on 4/9/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#pragma once

#include <StandardCplusplus.h>
#include <vector>
#include <numeric>
#include <algorithm>
#include "Rangefinder.h"

#define START_TOKEN   "("
#define VAL_SET_TOKEN "|"
#define VAL_SEPARATOR ","
#define BEGIN_HEADING "<"
#define END_HEADING   ">"
#define END_TOKEN     ")\n"

using namespace std;

class Packet {
public:
    float heading;
    vector<Range> RFData;

    Packet(float heading = 0, vector<Range> RFData = vector<Range>());
};
