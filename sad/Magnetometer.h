#ifndef _MAGNETOMETER_
#define _MAGNETOMETER_

#include <StandardCplusplus.h>
#include <vector>
#include <numeric>
#include <algorithm>

using namespace std;

#define DECLINATION_ANGLE 0    // in radians (Winona, MN)

class Magnetometer {
private:
  int heading;
  int address;
  int sdaPin;
  int sclPin;
  
public:
  Magnetometer(int address, int sdaPin, int sclPin);  

  int getHeading();
  
};

#endif

