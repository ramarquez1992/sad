#ifndef _MAGNETOMETER_
#define _MAGNETOMETER_

#include <StandardCplusplus.h>
#include <vector>
#include <numeric>
#include <algorithm>

using namespace std;

class Magnetometer {
private:
  int trigPin;
  int echoPin;
  
public:
  Magnetometer(int trigPin, int echoPin);  

  int getHeading();
  
};

#endif

