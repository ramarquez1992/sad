#ifndef _COMMSTATION_
#define _COMMSTATION_

#include <StandardCplusplus.h>
#include <vector>

#include <SoftwareSerial.h>
#include "Rangefinder.h"

using namespace std;

#define START_TOKEN "("
#define VAL_SET_TOKEN "|"
#define VAL_SEPARATOR ","
#define END_TOKEN ")\n"

typedef void (*cmdFuncPtr)();

class CommStation {
private:
  SoftwareSerial* serial;
  
public:
  CommStation(SoftwareSerial* serial);
  
  bool available();
  cmdFuncPtr getCmd();
  void sendString(String data);
  void sendData(vector<Range> data);
};

#endif

