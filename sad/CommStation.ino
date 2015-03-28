#include "CommStation.h"

CommStation::CommStation(SoftwareSerial* serial) {
  this->serial = serial;
}

bool CommStation::available() {
  bool result = false;
  
  if (serial->isListening()) {
    result = true;
  }
  
  return result;
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

// Format: "([number of rangefinders]|[range1 distance],[range1 angle]|[range2 distance],[range2 angle]|...)"
void CommStation::sendData(vector<Range> data) {
  int rangefinderCount = data.size();
  
  String str = START_TOKEN + String(rangefinderCount);
  
  for (int i = 0; i < rangefinderCount; ++i) {
    str += VAL_SET_TOKEN + String(data[i].centimeters) + VAL_SEPARATOR + String(data[i].angle);
  }
  
  str += END_TOKEN;
  sendString(str);
}

