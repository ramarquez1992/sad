//
//  CommStation.cpp
//  SAD
//
//  Created by Marquez, Richard A on 4/9/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#include "CommStation.h"

CommStation& CommStation::getInstance() {
    static CommStation instance;
    return instance;
}

CommStation::CommStation() {
    this->drone = Drone::getInstance();
    
    // Establish connection with base
    SoftwareSerial* bluetoothSerial;
    bluetoothSerial = new SoftwareSerial(BT_TX_PIN, BT_RX_PIN);
    bluetoothSerial->begin(BAUD_RATE);
    this->serial = bluetoothSerial;
}

bool CommStation::isAvailable() {
    bool result = false;

    if (serial->isListening()) {
        result = true;
    } else {
        // TODO: clear cache
    }

    return result;
}

bool CommStation::isBusy() {
    bool result = false;

    if (serial->peek() != -1) {
        result = true;
    }

    return result;
}

Command CommStation::getCmd() {
    Command cmd;

    if (serial->available()) {
        serial->flush();
        cmd.code = serial->read();
        cmd.argument = 10;
    }

    return cmd;
}

void CommStation::sendString(String str) {
    serial->write(str.c_str());
}

// Format: "([number of rangefinders]|[range1 distance],[range1 angle]|[range2 distance],[range2 angle]|...)"
void CommStation::sendPacket(Packet packet) {
    int rangefinderCount = packet.RFData.size();

    String str = START_TOKEN + String(rangefinderCount);

    for (int i = 0; i < rangefinderCount; ++i) {
        str += VAL_SET_TOKEN + String(packet.RFData[i].centimeters) + VAL_SEPARATOR + String(packet.RFData[i].angle);
    }

    str += String(BEGIN_HEADING) + int(packet.heading) + END_HEADING;
    str += END_TOKEN;
    sendString(str);
}

