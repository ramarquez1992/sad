/* TODO:
 * class for scan data
 * class for rangefinder
 */

#include <SoftwareSerial.h>
#include "CommStation.h"
#include "Motor.h"
#include "Rangefinder.h"


// Bluetooth LE (KEDSUM)
#define BT_TX_PIN 12 
#define BT_RX_PIN 11
#define BAUD_RATE 9600

// Right motor
#define H_ENABLE_PIN_1   6
#define H_CONTROL_PIN_1A 4
#define H_CONTROL_PIN_1B 5

// Left motor
#define H_ENABLE_PIN_2   3
#define H_CONTROL_PIN_2A 2
#define H_CONTROL_PIN_2B 1

// Front rangefinder (SunFounder HC-SR04)
#define RF1_TRIG_PIN 8
#define RF1_ECHO_PIN 9

CommStation* comm;
Motor* rMotor;
Motor* lMotor;
Rangefinder* fRangefinder;

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

Range** scan() {
  Range** data = (Range**)malloc(sizeof(Range) * 1);
  
  data[0] = fRangefinder->scan();
  
  return data;
}

void setup() {
  // Establish connection with base
  SoftwareSerial* bluetoothSerial;
  bluetoothSerial = new SoftwareSerial(BT_TX_PIN, BT_RX_PIN);
  bluetoothSerial->begin(BAUD_RATE);
  
  comm = new CommStation(bluetoothSerial);

  // Ready motors
  rMotor = new Motor(H_ENABLE_PIN_1, H_CONTROL_PIN_1A, H_CONTROL_PIN_1B);
  rMotor->setSpeed(10);
  
  lMotor = new Motor(H_ENABLE_PIN_2, H_CONTROL_PIN_2A, H_CONTROL_PIN_2B);
  lMotor->setSpeed(10);

  // Initialize rangefinders
  fRangefinder = new Rangefinder(RF1_TRIG_PIN, RF1_ECHO_PIN, 90);
}

void loop() {
  // Execute any available action
  cmdFuncPtr cmd = comm->getCmd();
  if (cmd != NULL) {
    cmd();
  }
  
  // Scan environment
  Range** data = scan();
  
  // Send scan data back to base
  comm->sendData(data);
  delete(data);
  
}



