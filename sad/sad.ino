/* TODO:
 * 
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
#define FRONT_RF_TRIG_PIN A0
#define FRONT_RF_ECHO_PIN A1
#define RIGHT_RF_TRIG_PIN A2
#define RIGHT_RF_ECHO_PIN A3
#define LEFT_RF_TRIG_PIN  A4
#define LEFT_RF_ECHO_PIN  A5

CommStation* comm;
Motor* rMotor;
Motor* lMotor;
Rangefinder* fRangefinder;
Rangefinder* rRangefinder;
Rangefinder* lRangefinder;

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
  Range** data = new Range*[3];
  
  data[0] = fRangefinder->ping();
  data[1] = rRangefinder->ping();
  data[2] = lRangefinder->ping();
  
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
  fRangefinder = new Rangefinder(FRONT_RF_TRIG_PIN, FRONT_RF_ECHO_PIN, 90);
  rRangefinder = new Rangefinder(RIGHT_RF_TRIG_PIN, RIGHT_RF_ECHO_PIN, 180);
  lRangefinder = new Rangefinder(LEFT_RF_TRIG_PIN, LEFT_RF_ECHO_PIN, 0);
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
  delete[] data;
  
}



