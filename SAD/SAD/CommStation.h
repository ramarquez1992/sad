//
//  CommStation.h
//  SAD
//
//  Created by Marquez, Richard A on 4/9/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

#pragma once

#include <StandardCplusplus.h>
#include <vector>
#include <SoftwareSerial.h>
#include "Drone.h"
#include "Packet.h"
#include "Rangefinder.h"
#include "Command.h"
#include "main.h"

using namespace std;

// Bluetooth LE (KEDSUM)
#define BT_TX_PIN 12
#define BT_RX_PIN 11
#define BAUD_RATE 9600

class CommStation {
private:
    Drone drone;
    SoftwareSerial* serial;
  
public:
    CommStation();
    static CommStation& getInstance();
    bool isAvailable();
    bool isBusy();
    Command getCmd();
    void sendString(String data);
    void sendPacket(Packet packet);
};
