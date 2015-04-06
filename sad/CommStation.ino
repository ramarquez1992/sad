#include "CommStation.h"

CommStation::CommStation(SoftwareSerial* serial) {
  this->serial = serial;
}

bool CommStation::isAvailable() {
  bool result = false;
  
  if (serial->isListening()) {
    result = true;
  } else {
    // TODO: clear cache
  }
  
  return result;
}

bool CommStation::isBusy() {
  bool result = false;
  
  if (serial->peek() != -1) {
    result = true;
  }
  
  return result;
}

cmdFuncPtr CommStation::getCmd() {
  cmdFuncPtr cmd = NULL;
  
  if (serial->available()) {
    serial->flush();
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
void CommStation::sendPacket(Packet packet) {
  int rangefinderCount = packet.RFData.size();
  
  String str = START_TOKEN + String(rangefinderCount);
  
  for (int i = 0; i < rangefinderCount; ++i) {
    str += VAL_SET_TOKEN + String(packet.RFData[i].centimeters) + VAL_SEPARATOR + String(packet.RFData[i].angle);
  }
  
  str += String(BEGIN_HEADING) + packet.heading + END_HEADING;
  str += END_TOKEN;
  sendString(str);
}

