#include <SoftwareSerial.h>

#define BT_TX_PIN 12 
#define BT_RX_PIN 11
#define BAUD_RATE 9600

#define H_ENABLE_PIN_1   6
#define H_CONTROL_PIN_1A 4
#define H_CONTROL_PIN_1B 5

#define H_ENABLE_PIN_2   3
#define H_CONTROL_PIN_2A 2
#define H_CONTROL_PIN_2B 1

SoftwareSerial BluetoothSerial(BT_TX_PIN, BT_RX_PIN);

void setup() {
  // Establish connection with base
  BluetoothSerial.begin(BAUD_RATE);
  
  // Configure H-bridge
  pinMode(H_ENABLE_PIN_1, OUTPUT);
  pinMode(H_CONTROL_PIN_1A, OUTPUT);
  pinMode(H_CONTROL_PIN_1B, OUTPUT);
  
  analogWrite(H_ENABLE_PIN_1, 10);
  digitalWrite(H_CONTROL_PIN_1A, LOW);
  digitalWrite(H_CONTROL_PIN_1B, LOW);
  
  pinMode(H_ENABLE_PIN_2, OUTPUT);
  pinMode(H_CONTROL_PIN_2A, OUTPUT);
  pinMode(H_CONTROL_PIN_2B, OUTPUT);
  
  analogWrite(H_ENABLE_PIN_2, 10);
  digitalWrite(H_CONTROL_PIN_2A, LOW);
  digitalWrite(H_CONTROL_PIN_2B, LOW);

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
        digitalWrite(H_CONTROL_PIN_1A, HIGH);
        digitalWrite(H_CONTROL_PIN_2A, HIGH);
        BluetoothSerial.write("Turned motors on\n");
        break;
      
      // Turn off motor
      case '-':
        digitalWrite(H_CONTROL_PIN_1A, LOW);
        digitalWrite(H_CONTROL_PIN_2A, LOW);
        BluetoothSerial.write("Turned motors off\n");
        break;
      
      // Unrecognized command
      default:
        BluetoothSerial.write("Unrecognized command\n");
    }
    
    // Scan environment
    
    // Send results back to base
    //BluetoothSerial.write(action);
    
  }
  
  
}
