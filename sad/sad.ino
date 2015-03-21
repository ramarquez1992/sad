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

void moveForward(int distance) {
  rMotor.accelerate();
  lMotor.accelerate();
  
  delay(distance);
  
  rMotor.brake();
  lMotor.brake();
}

void moveBackward(int distance) {
  rMotor.reverse();
  lMotor.reverse();
  
  delay(distance);
  
  rMotor.brake();
  lMotor.brake();
}

void turnRight(int degrees) {
  rMotor.reverse();
  lMotor.accelerate();
  
  delay(degrees);
  
  rMotor.brake();
  lMotor.brake();
}

void turnLeft(int degrees) {
  rMotor.accelerate();
  lMotor.reverse();
  
  delay(degrees);
  
  rMotor.brake();
  lMotor.brake();
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
        moveForward(500);
        BluetoothSerial.write("MOVING FORWARD\n");
        break;
        
      case '=':
        moveBackward(500);
        BluetoothSerial.write("MOVING BACKWARD\n");
        break;
      
      // Turn off motor
      case '-':
        rMotor.brake();
        lMotor.brake();
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
