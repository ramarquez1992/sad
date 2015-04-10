#ifndef _MAGNETOMETER_
#define _MAGNETOMETER_

#include <StandardCplusplus.h>
#include <vector>
#include <numeric>
#include <algorithm>

#include <HMC5883L.h>

using namespace std;

#define DECLINATION_ANGLE 0.0    // in radians (Winona, MN)

class Magnetometer : public HMC5883L {
private:
  float heading;
  
public:
  Magnetometer();  
  float getHeading();
  
};

#endif

