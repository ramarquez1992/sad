#include <SoftwareSerial.h>

#define BT_SERIAL_TX_DIO 11 
#define BT_SERIAL_RX_DIO 10
#define BAUD_RATE 9600
#define MOTOR_PIN 9

SoftwareSerial BluetoothSerial(BT_SERIAL_TX_DIO, BT_SERIAL_RX_DIO);

void setup() {
  // Establish connection with base
  BluetoothSerial.begin(BAUD_RATE);
  
  // Configure motor
  pinMode(MOTOR_PIN, OUTPUT);
  digitalWrite(MOTOR_PIN, LOW);

}

void loop() {
  if (BluetoothSerial.available()) {
    // Get next action from base
    char action = BluetoothSerial.read();
    
    // Execute action
    switch (action) {
      // Turn on motor
      case '+':
      case '=':
        digitalWrite(MOTOR_PIN, HIGH);
        break;
      
      // Turn off motor
      case '-':
        digitalWrite(MOTOR_PIN, LOW);
        break;
      
      // Unrecognized command
      default:
        digitalWrite(MOTOR_PIN, LOW);
    }
    
    // Scan environment
    
    // Send results back to base
    BluetoothSerial.write(action);
    
  }
  
}
