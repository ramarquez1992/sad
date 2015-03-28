#include "CommStation.h"

CommStation::CommStation(SoftwareSerial* serial) {
  this->serial = serial;
}

bool CommStation::available() {
  bool result = false;
  
  if (serial->isListening()) {
    result = true;
  } else {
    //clear cache
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
        break;
        
      case 'b':
        cmd = moveBackward;
        break;
      
      // Turn
      case 'r':
        cmd = turnRight;
        break;
        
      case 'l':
        cmd = turnLeft;
        break;
        
      // Turn off motor
      case ' ':
        cmd = brake;
        break;
      
      // Unrecognized command
      default:
        ;//sendString("UNRECOGNIZED COMMAND\n");
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

