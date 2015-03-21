#include <SoftwareSerial.h>
#include "Motor.h"

// Bluetooth LE
#define BT_TX_PIN 12 
#define BT_RX_PIN 11
#define BAUD_RATE 9600

// Right motor
#define H_ENABLE_PIN_1   6
#define H_CONTROL_PIN_1A 4
#define H_CONTROL_PIN_1B 5

// Left Motor
#define H_ENABLE_PIN_2   3
#define H_CONTROL_PIN_2A 2
#define H_CONTROL_PIN_2B 1

SoftwareSerial BluetoothSerial(BT_TX_PIN, BT_RX_PIN);
Motor rMotor(H_ENABLE_PIN_1, H_CONTROL_PIN_1A, H_CONTROL_PIN_1B);
Motor lMotor(H_ENABLE_PIN_2, H_CONTROL_PIN_2A, H_CONTROL_PIN_2B);

void brake() {
  rMotor.stop();
  lMotor.stop();
}

void moveForward() {
  rMotor.accelerate();
  lMotor.accelerate();
}

void moveForward(int distance) {
  moveForward();
  delay(distance);
  brake();
}

void moveBackward() {
  rMotor.reverse();
  lMotor.reverse();
}

void moveBackward(int distance) {
  moveBackward();
  delay(distance);
  brake();
}

void turnRight() {
  rMotor.reverse();
  lMotor.accelerate();
}

void turnRight(int degrees) {
  turnRight();
  delay(degrees);
  brake();
}

void turnLeft() {
  rMotor.accelerate();
  lMotor.reverse();
}

void turnLeft(int degrees) {
  turnLeft();
  delay(degrees);
  brake();
}

void setup() {
  // Establish connection with base
  BluetoothSerial.begin(BAUD_RATE);

  // Ready motors
  rMotor.setSpeed(10);
  lMotor.setSpeed(10);

}

void loop() {
  if (BluetoothSerial.available()) {
    // Get next action from base
    char action = BluetoothSerial.read();
    
    // Execute action
    switch (action) {
      // Turn on motor
      case '+':
        moveForward();
        BluetoothSerial.write("MOVING FORWARD\n");
        break;
        
      case '=':
        moveBackward();
        BluetoothSerial.write("MOVING BACKWARD\n");
        break;
      
      // Turn off motor
      case '-':
        brake();
        BluetoothSerial.write("BRAKING\n");
        break;
      
      // Unrecognized command
      default:
        BluetoothSerial.write("UNRECOGNIZED COMMAND\n");
    }
    
    // Scan environment
    
    // Send results back to base
    //BluetoothSerial.write(action);
    
  }
  
  
}
