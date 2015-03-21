#ifndef _COMMSTATION_
#define _COMMSTATION_

#include <SoftwareSerial.h>
#include "Rangefinder.h"

typedef void (*cmdFuncPtr)();

class CommStation {
private:
  SoftwareSerial* serial;
  
public:
  CommStation(SoftwareSerial* serial);
  ~CommStation();
  
  cmdFuncPtr getCmd();
  void sendData(char* data);
  void sendData(Range** data);

};

#endif