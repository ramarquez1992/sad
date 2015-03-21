#include "CommStation.h"

CommStation::CommStation(SoftwareSerial* serial) {
  this->serial = serial;
}

cmdFuncPtr CommStation::getCmd() {
  cmdFuncPtr cmd = NULL;
  
  if (serial->available()) {
    char action = serial->read();
    
    // Parse action
    switch (action) {
      // Move
      case 'f':
        cmd = moveForward;
        sendString("MOVING FORWARD\n");
        break;
        
      case 'b':
        cmd = moveBackward;
        sendString("MOVING BACKWARD\n");
        break;
      
      // Turn
      case 'r':
        cmd = turnRight;
        sendString("TURNING RIGHT\n");
        break;
        
      case 'l':
        cmd = turnLeft;
        sendString("TURNING LEFT\n");
        break;
        
      // Turn off motor
      case ' ':
        cmd = brake;
        sendString("BRAKING\n");
        break;
      
      // Unrecognized command
      default:
        sendString("UNRECOGNIZED COMMAND\n");
    }
    
  }
  
  return cmd;
}

void CommStation::sendString(String str) {
  serial->write(str.c_str());
}

// Format: "^[number of rangefinders]|[range1 distance],[range1 angle]|[range2 distance],[range2 angle]|...$"
void CommStation::sendData(Range** data) {
  int rangefinderCount = sizeof(data) / sizeof(Range);
  String str = "^" + rangefinderCount;
  
  for (int i = 0; i < rangefinderCount; ++i) {
    str += "|" + String(data[i]->centimeters) + "," + String(data[i]->angle);
  }
  
  str += "$";
  sendString(str);
}

