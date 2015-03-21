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
        sendData("MOVING FORWARD\n");
        break;
        
      case 'b':
        cmd = moveBackward;
        sendData("MOVING BACKWARD\n");
        break;
      
      // Turn
      case 'r':
        cmd = turnRight;
        sendData("TURNING RIGHT\n");
        break;
        
      case 'l':
        cmd = turnLeft;
        sendData("TURNING LEFT\n");
        break;
        
      // Turn off motor
      case ' ':
        cmd = brake;
        sendData("BRAKING\n");
        break;
      
      // Unrecognized command
      default:
        sendData("UNRECOGNIZED COMMAND\n");
    }
    
  }
  
  return cmd;
}

void CommStation::sendData(char* data) {
  serial->write(data);
}

CommStation::~CommStation() {
  //
}

