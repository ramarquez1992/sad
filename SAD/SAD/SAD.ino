#include "main.h"
#include "Arduino.h"
#include <SoftwareSerial.h>
#include <TimedAction.h>

#include "CommStation.h"
#include "Motor.h"
#include "Rangefinder.h"
#include "Packet.h"
#include "Magnetometer.h"

CommStation* comm;
Motor* rMotor;
Motor* lMotor;
Rangefinder* fRangefinder;
Rangefinder* rRangefinder;
Rangefinder* lRangefinder;
Magnetometer* magnetometer;

void brake() {
    rMotor->stop();
    lMotor->stop();
}

void moveForward() {
    rMotor->accelerate();
    lMotor->accelerate();
}

void moveBackward() {
    rMotor->reverse();
    lMotor->reverse();
}

void turnRight() {
    rMotor->reverse();
    lMotor->accelerate();
}

void turnLeft() {
    rMotor->accelerate();
    lMotor->reverse();
}


Packet scan() {
    int totalScans = 10; // 1ms total time
    vector<Range> RFData;
    
    RFData.push_back(fRangefinder->avgPing(totalScans));
    //RFData.push_back(lRangefinder->avgPing(totalScans));
    //RFData.push_back(rRangefinder->avgPing(totalScans));
    
    int heading = magnetometer->getHeading();
    
    return Packet(heading, RFData);
}


void bgScan() {
    Packet p = scan();
    
    if (!comm->isBusy()) {
        comm->sendPacket(p);
    }
    
}

void setup() {
    // Establish connection with base
    SoftwareSerial* bluetoothSerial;
    bluetoothSerial = new SoftwareSerial(BT_TX_PIN, BT_RX_PIN);
    bluetoothSerial->begin(BAUD_RATE);
    
    comm = new CommStation(bluetoothSerial);
    
    int initialSpeed = 255;
    // Ready motors
    rMotor = new Motor(H_ENABLE_PIN_1, H_CONTROL_PIN_1A, H_CONTROL_PIN_1B);
    rMotor->setSpeed(initialSpeed);
    
    lMotor = new Motor(H_ENABLE_PIN_2, H_CONTROL_PIN_2A, H_CONTROL_PIN_2B);
    lMotor->setSpeed(initialSpeed);
    
    // Initialize rangefinders
    fRangefinder = new Rangefinder(FRONT_RF_TRIG_PIN, FRONT_RF_ECHO_PIN, 0);
    //rRangefinder = new Rangefinder(RIGHT_RF_TRIG_PIN, RIGHT_RF_ECHO_PIN, 90);
    //lRangefinder = new Rangefinder(LEFT_RF_TRIG_PIN, LEFT_RF_ECHO_PIN, 270);
    
    magnetometer = new Magnetometer();
}

TimedAction scanAction = TimedAction(100, bgScan);

void loop() {
    if (comm->isAvailable()) {
        // Execute any available action
        cmdFuncPtr cmd = comm->getCmd();
        if (cmd != NULL) {
            cmd();
        }
        
        scanAction.check();
    }
    
}

