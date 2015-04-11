//
//  Packet.cpp
//  SAD
//
//  Created by Marquez, Richard A on 4/11/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#include "Packet.h"

Packet::Packet(float heading, vector<Range> RFData) {
    this->heading = heading;
    this->RFData = RFData;
}
