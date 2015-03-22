#ifndef _COMMSTATION_
#define _COMMSTATION_

#include <SoftwareSerial.h>
#include "Rangefinder.h"

#define START_TOKEN   "^"
#define VAL_SET_TOKEN "|"
#define VAL_SEPARATOR ","
#define END_TOKEN     "$"

typedef void (*cmdFuncPtr)();

class CommStation {
private:
  SoftwareSerial* serial;
  
public:
  CommStation(SoftwareSerial* serial);
  
  cmdFuncPtr getCmd();
  void sendString(String data);
  void sendData(Range** data);
};

#endif

